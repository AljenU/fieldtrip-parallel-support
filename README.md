# fieldtrip-parallel-work

This repo contains work in progress for  the [FieldTrip](https://www.fieldtriptoolbox.org/) Parallelization [project](https://github.com/fieldtrip/fieldtrip/projects/5) and in particular [this issue](https://github.com/fieldtrip/fieldtrip/issues/1853).

## General

This is not intended to be a long-lived repo or software project in itself: it documents the work done for a specific work project in 2021. Useful code and results will be either upstreamed to FieldTrip itself or spun out to a separate repo, if they're considered sufficiently valuable.

The code here is intended to work as far back as Matlab R2016b, but was mostly tested on R2019b and R2022a.

## Repo Contents

### Tutorial and Example Functions

The `Mcode` directory is the code from the [FieldTrip Tutorials](https://www.fieldtriptoolbox.org/tutorial/) converted to functions which can be run without arguments, and with a common environment configuration, to support benchmarking of the FieldTrip code.

These are effectively versions of the `test_tutorial_*.m` test scripts in the [FieldTrip test/ directory](https://github.com/fieldtrip/fieldtrip/tree/master/test) which can be run outside of the environment of the Donders network.

These tutorial functions are structured so that they can be run without depending on your Matlab session's current working directory. This allows you to run them while you're `cd`'ed to their source code while working on them, or `cd`'ed to the FieldTrip repo to look at its code easily, or anywhere else. This means that the path references in the code have all been modified to replace relative paths with full paths using `ft_tut_datadir` (a new function introduced specifically for this scaffolding code).

Most of the tutorial code has been pretty much unmodified, also without attempting to make the code Mlint-clean.

The tutorial functions do not return anything useful. If you want to see their results, you will generally want to put a Matlab debugger breakpoint at the final `end` of the function and then run it.

Running the tutorial functions may have the following side effects:

* They may use blocking GUI functions, so manual interaction may be required to complete them.
* They may leave new figures up.
* They may write or delete any data under `ft_tut_workdir`.

The function sets are:

* `ft_tut_*` - Based on the [FieldTrip Tutorials](https://www.fieldtriptoolbox.org/tutorial/).
* `ft_ex_*` - Based on the [FieldTrip Example Scripts](https://www.fieldtriptoolbox.org/example/).
* `ft_tut_datadir`, `ft_tut_workdir` - Configuration functions for this code.
* `ft_bench_*` - Adapted versions of tutorials / examples / tests to get more useful timing information for specific fieldtrip functions.

### Timing Functions

The `Timingscripts` directory contains code to be able to time the performance of specific fieldtrip functions.

## Usage

- Edit setup.m in the `Timingscripts` directory so it has the correct paths for your computer. Read the comment at the top of that file, to see what the directory structures should look like, and where to get the test data.
- In a fresh matlab session, first run the setup.m in the `Timingscripts` directory. This will add all needed things to the path.
- Next run timings(testfun, changeState) to record timing information for the testfun at the currect changeState. See timings.m in the `Timingscripts` directory for valid values of the inputs.

## Author and Project

Initially developed by [Andrew Janke](https://apjanke.net) on [this apjanke/fieldtrip-parallel-work repo on GitHub](https://github.com/apjanke/fieldtrip-parallel-work).
