#!/bin/bash


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Building toolchain..."

make -C $DIR/code

mkdir -p $DIR/results
mkdir -p $DIR/tmp
mkdir -p $DIR/space

rm -f $DIR/results/*
rm -f $DIR/tmp/*

gunzip $DIR/github_scrape/*

$DIR/code/bin/mutgen -d $DIR/clanguage.def -x $DIR/mutants.dat -i $DIR/github_scrape/*.git --trim-text --allow-adjacent

gcc -w $DIR/space_orig/space.c -o $DIR/space_orig/space_orig -lm

uid=0

pass=0
fail=0
total=0

compiled=0
compfailed=0
comptotal=0

while read mutant; do
	cp $DIR/space_orig/space.c $DIR/space
	cp $DIR/space_orig/strutt.h $DIR/space

	$DIR/code/bin/mutins -x $DIR/mutants.dat -m $mutant -i 0 -t $DIR/space/space.c

	let "comptotal += 1"

	rm -f $DIR/results/$mutant.txt
	rm -f $DIR/tmp/*

	if gcc -w $DIR/space/space.c -o $DIR/space/space_mutated -lm; then
		let "compiled += 1"

		for fn in $DIR/inputs/*.adl; do
			rfn=${fn%.adl}

			let "uid += 1"

			$DIR/space/space_mutated $rfn &> $DIR/tmp/$uid.txt

			if [ $? -eq 139 ]; then
				echo "SEGFAULT" > $DIR/tmp/$uid.txt
				rm -f core.*
			fi

			$DIR/space_orig/space_orig $rfn &> $DIR/tmp/orig$uid.txt

			if [ $? -eq 139 ]; then
				echo "SEGFAULT" > $DIR/tmp/orig$uid.txt
				rm -f core.*
			fi

			if cmp -s $DIR/tmp/$uid.txt $DIR/tmp/orig$uid.txt; then
				echo "P" >> $DIR/results/$mutant.txt
			else
				echo "F" >> $DIR/results/$mutant.txt
			fi



		done

		for i in `seq 1 5000`; do
			rm -f $DIR/tmp/tc
			shuf -n 100 $DIR/results/$mutant.txt > $DIR/tmp/tc
			if grep -Fxq F $DIR/tmp/tc; then
				let "fail += 1"
			else
				let "pass += 1"
			fi
		done

		let "total += 5000"

	else
		let "compfailed += 1"
		echo "X" >> $DIR/results/$mutant.txt
	fi

	echo $pass
	echo $fail
	echo $total

done < $DIR/mutants.list

ams=$(echo "scale=2; $fail/$total" | bc)

echo "Am(S) = $ams"

comprate=$(echo "scale=1; 100 * $compiled / $comptotal" | bc)

echo "Compilation rate: $comprate%"


echo "Cleaning up"

rm -rf $DIR/tmp
rm -rf $DIR/space
rm -rf $DIR/results

