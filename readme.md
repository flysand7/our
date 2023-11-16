
# Odin user repository

This is a collection of packages created and mantained by the Odin
community. This repository contains foreign library wrappers, bindings,
utility packages that do not necessarily belong to `core:` and `vendor:`
packages. 

In order to prevent dependency hell and other issues related to packaging,
the packages in this repository are held to some degree of standard. More
on that below.

## How to use

Simply clone the repository and set the path to `our` collection in your
odin build flags.

```
$ git clone git@github.com:flysand7/our.git
$ odin build your_project -collection:our=path/to/our/packages
```

You can import any of the packages using standard imports.

```
import "our:some_package"
```

## Repository structure

You can see an example of the directory structure for this repository:

```
packages/
  +- mylib/
tests/
  |- all/
  |    |- all_amd64.odin
  |    |- all_linux.odin
  |    |- ...
  +- mylib/
examples/
  +- mylib/
       |- example1/
       |    +- example1.odin
       +- example2/
            +- example2.odin
```

This structure resembles Odin's repository in some places. The packages
themselves are contained within `packages` directory in the repository root.

The tests for these packages, in case there are any, can be put into `tests`
directory. Some packages are hard to write automated tests for, especially if
those packages involve a lot of side effects. Therefore it's not required for
any given package to implement tests. The `all` tests must contain an `include`
statement for every package in the `packages` directory.

The examples directory can contain the example code for packages. Think about
it as the directory anyone would go to to get a quick look at how someone might
start with that particular package, e.g. the basic usage. More examples can be
added. The code in examples needs to be able to be ran with `odin run`.

## Contributing

There's many ways to set your local repository for contributing, but I'll list
a sequence of steps that's generally going to apply. Just to note it doesn't
matter how you set it up. If you only plan to do a single pull request to fix
a minor issue, you cna just do it from your fork directly. This tutorial is
directed at people who plan on submitting multiple pull requests.

### Setting up local git repository for contributing.

Set up remote repositories:

1. Clone the *original* repository. (most likely you've already done this ;D)
2. Make a fork of `our`.

```bash
$ git clone https://github.com/flysand7/our.git
$ cd our
```

Set up git remotes in your local repository (do it just once):

1. Create `upstream` remote and point it to this repo.
2. Set the `origin` remote to your fork.

```bash
$ git remote add upstream https://github.com/flysand7/our.git  # Pull from here
$ git remote set-url origin git@github.com:your_name/our.git   # Commit here by default
```

For every pull request:

1. Checkout to main and update
2. Create a branch for your pull requests.
3. Set the remote on the new branch to your fork.
4. Commit the changes to the PR branch.
5. Push the changes! Github should tell you what to do next.

```bash
$ git checkout main          # Switch to `main` branch
$ git pull upstream main     # Update the `main` branch
$ git checkout -b my_fork    # Create a new branch for your fork
$ git push -u origin my_fork # Set the upstream to your repo (`origin`)
# Implement the PR changes and just push them. Your PR is ready!
```

### Before pushing...

In case you want to add a package to `our`, make sure that it doesn't
contain syntax errors, and can compile with maximum strictness
compiler options. To check you can run

```
odin check examples/all -vet -strict-style
```

## Guidelines

Every package in this repository is required to follow a specific
set of guidelines in order to enhance usability and inclusivity in
various projects.

### Style/general

Your package must:

1. Be compileable with different compiler options:
    - `-vet`
    - `-strict-style`
    - `-disallow-do`
    - `-vet-using-param`

2. Follow Odin's identifier naming scheme on non-foreign identifiers.
    - Types, Enumeration constants: `Ada_Case`
    - Functions, variables: `smoll_snake`
    - Constants: `LARGE_SNAKE`
    - Use tabs for indentation, spaces for alignment.

3. Readability concerns:
    - Avoid lines longer than 100 characters.
    - Avoid using (mutable) named tuple returns.

4. Common naming patterns:
    - `create_*`  - for procedures that return initialized objects without
       allocating memory
    - `init_*`    - for procedures that initialize by pointer
    - `new_*`     - for procedures that allocate zero-initialized objects
    - `make_*`    - for procedures that allocate and initialize objects
    - `destroy_*` - deletes `init`-ed object
    - `free_*`    - deletes an object made using `new`
    - `delete_*`  - deletes an object made using `make`

5. Writing ffi bindings:
    - Write wrappers for all foreign imported functions.
    - The wrappers must be named using Odin style
    - The wrappers must account for type-safety whenever
      possible/reasonable. Make sure the user doesn't need to
      cast too much.
    - The wrappers must use Odin's slices instead of ptr+len
      pairs. This doesn't apply to structs.
    - In case the wrapper changes the name of the original
      procedure too much, the wrapper should include a docstring
      including the name of the original function.

6. Dependencies:
    - The packages in this repository are not allowed to depend on
      other packages in this repository.
    - Dependencies on `core:` are allowed.
    - Dependencies on `vendor:` are allowed but discouraged.
