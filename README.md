# Bio Brew

## Introduction

Imagine you land in a hostile machine that does not have your typical use of tools or perhaps
they are out of date. Also, you don't have root access. BB allows you to install your 
favorite tools in your home directory in a very easy way. 

* PROs
  + small code base
  + bioinformatics package oriented
* CONs
  + No bootstrapping (you need some set of userland apps already in place)
  + too much linux dependent
  + small number of recipes

## Install

  <pre>
  $ # Download the master branch using curl
  $ # -L follow redirects; -s silent; -S show error message if fails; -f fail silently on server errors
  $ curl -LsSf http://github.com/drio/bio.brew/tarball/master | tar xvz -C. --strip 1
  </pre>

## TODO 

1. Create more recipes.
  * Generic:
    + DONE libevent
    + DONE cdargs
    + DONE tmux
    + DONE vim
    + DONE git
    + DONE ruby  
    + DONE perl
    + DONE java
    + DONE svn

  * Bio:
    + bwa
    + bfast
    + dnaa
    + srma
    + gatk
    + picard
    + R
    + samtools
