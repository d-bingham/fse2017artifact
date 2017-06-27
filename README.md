# The Care and Feeding of Wild-Caught Mutants -- Artifact

This artifact provides the toolchain used in the paper and implements a
small subset of the experimentation performed in the paper; the subset used 
is necessary for artifact submission as the
experiment as performed for the paper required tens of thousands of hours
of processor time (and as such was executed on a high-throughput computing
platform).

## Important files and directories
  * [The Care and Feeding of Wild-Caught Mutants](paper.pdf) - The paper as submitted
  * [Dockerfile](Dockerfile) - A Dockerfile which, when built, compiles the toolchain and runs the 	     experiment subset 
  *	[Wild-Caught Mutant Demo video](wcm_demo.mp4) - A narrated video showing a brief demo of the toolchain
  * [mutrun.sh](mutrun.sh) - A bash script which executes a subset of the experiment; this should work on *most* Linux systems (see below), but for evaluation of the artifact using the Docker instance is strongly preferred
  * [code](code) - Source code for the Wild-Caught Mutants toolchain
  * [github_scrape](github_scrape) - A subset of the source 
	control repository revision histories utilized in the experiment (specifically, the Linux kernal revision history is omitted for space and time concerns)

## Instructions for use

A [Dockerfile](Dockerfile) is provided to automate the 
process of executing the experimental subset.  Building the Docker
instance from the Dockerfile (e.g., `docker build .` from the artifact's root
directory, `sudo` use often required) will automatically run the experiment script 
and display the results.

The toolchain (mutgen and mutins) can be built from the [code](code) directory 
with make.

The experimental subset (which builds the toolchain, harvests a set of mutants, 
and performs a subset of the paper's experimentation) is performed by the 
[mutrun.sh](mutrun.sh) script.  The experimental subset 
performed by this script is chosen to take roughly half an hour on
typical desktop hardware.


## Note!

We have noticed some unusual behavior with the test suites when using certain 
versions of gcc, especially gcc version 6.  As we do not currently have the
resources to exhaustively test the experiment across a wide variety of 
environments, we strongly suggest use of the provided Docker container.

## Evaluation

This artifact is designed to provide both the tools developed for the paper and an
	example of the experiment.

Due to the sheer size of the experimentation performed for the paper, it is not
	feasible to have the artifact duplicate these; we provide a subset of both the 
	corpus to harvest a set of mutants from, and a randomly selected subset of 
	mutation operators to insert into the system under test.

## Notes

  * As the test suites used to calculate the Am(S) score for the experiment
	are generated randomly, the Am(S) score provided at the end of the 
	experiment can vary from run to run.
  * The toolchain has been evolving steadily since the initial submission
	of the paper; as a result, this artifact shows significant improvements
	in both compilation rate and Am(S) scores (note that we consider
	*lower* Am(S) scores to be more desirable)
	over the experimental results reported in the paper.
  * This artifact omits an idiomization pass and identifier shifts and
	instead focuses entirely on syntactic mutation operators due to 
	time constraints for running the artifact.
