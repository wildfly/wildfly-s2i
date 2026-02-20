Contributing to WildFly S2I project
=====================

Welcome to the WildFly S2I project! We welcome contributions from the community. 
This guide will walk you through the steps for getting started on our project.

- [Legal](#legal)
- [Forking the Project](#forking-the-project)
- [Issues](#issues)
- [Setting up your Developer Environment](#setting-up-your-developer-environment)
- [Contributing Guidelines](#contributing-guidelines)

## Legal

All contributions to this repository are licensed under the [Apache License](https://www.apache.org/licenses/LICENSE-2.0), version 2.0 or later, or, if another license is specified as governing the file or directory being modified, such other license.

All contributions are subject to the [Developer Certificate of Origin (DCO)](https://developercertificate.org/).
The DCO text is also included verbatim in the [dco.txt](dco.txt) file in the root directory of the repository.

### Compliance with Laws and Regulations

All contributions must comply with applicable laws and regulations, including U.S. export control and sanctions restrictions.
For background, see the Linux Foundation’s guidance:
[Navigating Global Regulations and Open Source: US OFAC Sanctions](https://www.linuxfoundation.org/blog/navigating-global-regulations-and-open-source-us-ofac-sanctions).


## Forking the Project 
To contribute, you will first need to fork the [wildfly-s2i](https://github.com/wildfly/wildfly-s2i) repository. 

This can be done by looking in the top-right corner of the repository page and clicking "Fork".

The next step is to clone your newly forked repository onto your local workspace. 
This can be done by going to your newly forked repository, which should be at `https://github.com/USERNAME/wildfly-s2i`. 

Then, there will be a green button that says "Code". Click on that and copy the URL.

Then, in your terminal, paste the following command:
```bash
git clone [URL]
```
Be sure to replace [URL] with the URL that you copied.

Now you have the repository on your computer!

## Issues
This project uses Github Issues to manage issues. All issues can be found [here](https://github.com/wildfly/wildfly-s2i/issues). 

## Setting up your Developer Environment
You will need:

* [cekit](https://github.com/cekit/cekit) 4.3.0 minimum version. Installation [instructions](https://docs.cekit.io/en/latest/handbook/installation/index.html)
* Git
* An [IDE](https://en.wikipedia.org/wiki/Comparison_of_integrated_development_environments#Java)
(e.g., [IntelliJ IDEA](https://www.jetbrains.com/idea/download/), [Eclipse](https://www.eclipse.org/downloads/), etc.)

First `cd` to the directory where you cloned the project (eg: `cd wildfly-s2i`)

Add a remote ref to upstream, for pulling future updates.
For example:

```
git remote add upstream https://github.com/wildfly/wildfly-s2i
```

To build S2I builder and runtime images look at this : [Readme](https://github.com/wildfly/wildfly-s2i/blob/main/README.md#building-the-images).

To run the behave tests:

```
cd wildfly-builder-image
cekit test behave
```


## Contributing Guidelines

When submitting a PR, please keep the following guidelines in mind:

1. In general, it's good practice to squash all of your commits into a single commit. For larger changes, it's ok to have multiple meaningful commits. If you need help with squashing your commits, feel free to ask us how to do this on your pull request. We're more than happy to help!

2. Please include the GitHub issue you worked on in the title of your pull request and in your commit message. 

3. Please include the link to the GitHub issue you worked on in the description of the pull request.
