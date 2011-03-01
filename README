# Bio Brew

## Introduction

Imagine you get access to a new linux box or HPC cluster. You want to start doing 
your analysis, coding, data-mining but you do not have your toolbox available. Yes, 
you can ask the sysadmins to install that for you. That may work. You may also install
the tools yourself. 

BB (biobrew) helps you either way. With a simple oneliner you can have most of your
tools ready to use.  BB is a tiny package manager based entirely in bash. It makes the 
extension of recipes (package definitions) very easy. 

BB currently works in Linux enviroments (it should work just fine in other flavours of 
Unix). It only needs a typical Linux enviroment with gcc and curl. Besides my classic 
and inseparable unix tools bb comes with some bioinformatics gems.  

Give it a try and make it better by improving the framework and adding more recipes.

## Install (without git)

$ # Download the master branch using curl
$ # -L follow redirects; -s silent; -S show error message if fails; -f fail silently on server errors
$ curl -LsSf http://github.com/drio/bio.brew/tarball/master | tar xvz -C. --strip 1

You probably want to add ./load_env in your shell's configuration file. If you use bash add
this to your .bashrc:

source /data/rogers/drio_scratch/bb/load_env    

That will set the proper path(s). Take a quick peek to load_env, it is a very small script.

At that point you can use ./bin/bb to list, install or remove recipes. You can also run the 
``tests/do_all.sh`` script to install all the recipes. That may take some time (20 minutes 
in a fairly powerful machine with 8 cores and using bb -j8 install).

Once installed the binaries will be in your path so you can just call them. Keep in mind 
some recipes (packages) do not generate binary files, for those cases, bb creates special
scripts (log/*.sh) and the necessary ENV vars are created. For example, picard is a bunch
of jars that cannot be executed directly. By loading the recipe's enviroment you will 
have a ENV variable called PICARD that points to the jars. It is then very easy to 
use the jars as necessary.

Here is a list of the recipes available (This is an old version, there are more 
packages now):

$ ./bin/bb list
- : ant                      :  java
- : bfast                    :  
- : bwa                      :  svn
- : cdargs-1.35              :  
- : dnaa                     :  samtools bfast
- : gatk                     :  java
- : git-1.7.3.2              :  
- : java                     :  
- : libevent-1.4.14b-stable  :  
- : perl-5.12.2              :  
- : picard                   :  java
- : R-2.12.0                 :  
- : ruby-1.9.2-p0            :  
- : samtools                 :  svn
- : srma                     :  samtools ant picard java
- : subversion-1.6.13        : 
- : tmux-1.3                 :  libevent-1.4.14b-stable
- : vim73                    :  

As you can see, I don't have any installed ('-'). I can now install something:

$ ./bin/bb -j8 install svn
Sun Oct 31 11:19:38 CDT 2010 >> Installing recipe: svn
Sun Oct 31 11:19:38 CDT 2010 >> recipe script found
Sun Oct 31 11:19:38 CDT 2010 >> downloading [http://subversion.tigris.org/downloads/subversion-1.6.13.tar.gz]
Sun Oct 31 11:19:49 CDT 2010 >> decompressing tarball: subversion-1.6.13.tar.gz (tar.gz)
Sun Oct 31 11:19:59 CDT 2010 >> downloading [http://subversion.tigris.org/downloads/subversion-deps-1.6.13.tar.gz]
Sun Oct 31 11:20:05 CDT 2010 >> decompressing tarball: subversion-deps-1.6.13.tar.gz (tar.gz)
Sun Oct 31 11:20:13 CDT 2010 >> running configure [logging output: /data/rogers/drio_scratch/bb/logs/subversion-1.6.13.configure.log.txt]
Sun Oct 31 11:21:23 CDT 2010 >> running make on tool [logging output: /data/rogers/drio_scratch/bb/logs/subversion-1.6.13.make.log.txt] [j: 8]
Sun Oct 31 11:22:55 CDT 2010 >> installing tool [logging output: /data/rogers/drio_scratch/bb/logs/subversion-1.6.13.install.log.txt]
Sun Oct 31 11:23:16 CDT 2010 >> linking from staging area [bin/svn]
Sun Oct 31 11:23:16 CDT 2010 >> recipe [subversion-1.6.13] installed.
Sun Oct 31 11:23:16 CDT 2010 >> removing lock. [/data/rogers/drio_scratch/bb/logs/subversion-1.6.13.lock]
Sun Oct 31 11:23:16 CDT 2010 >> touching install flag [/data/rogers/drio_scratch/bb/logs/subversion-1.6.13.installed]

$ ls -acl ./local/bin/svn
./local/bin/svn

## TODO

+ Allow specific options for actions (-j should not be generic, only for install).
+ Extend readme to should how to deal with jars.
