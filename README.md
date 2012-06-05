YaST Metapackage library for Python
===================================

This library provides support for
[YaST metapackages](http://en.opensuse.org/openSUSE:One_Click_Install),
as used, among other places, by openSUSE's
[build service](http://build.opensuse.org).

What is a YaST Metapackage?
---------------------------
A _YaST metapackage_ is an XML file describing repositories and
software packages; it is meant to allow setting up the specified
repositories, and installing the specified software, with a single
click on a website.

Installation
------------
python setup.py install

Who should use this
-------------------
Up to now, openSUSE and SLES are the only distribution that support
YMP files, and therefore the build service no longer generates YMP
one-click install descriptors for other distributions. It is hoped
that once this package is available, those install descriptors could
be re-enabled.

For now, this tool might be of use for those who want to streamline
setting up repositories and installation of packages from said
repositories.

Installation
------------
This package will be posted on PyPI once it's ready

License
-------
Copyright © 2012 Michel Alexandre Salim. Distributed under the MIT
license. See the file `LICENSE`. For a humorous
[poetic](https://github.com/alexgenaud/Poetic-License/blob/master/README)
"translation" of the terms, read on:

    This work ‘as-is’ we provide.
    No warranty express or implied.
    We’ve done our best,
    to debug and test.
    Liability for damages denied.

    Permission is granted hereby,
    to copy, share, and modify.
    Use as is fit,
    free or for profit.
    These rights, on this notice, rely.
