# Notes on this repo

### Source

This was forked from another repo, so keep that in mind.

### Installing & Running

There is a dockerfile in the repo. A few notes:

1. To run everything, first build the image
```
docker build . -t jekyll
```

1. Run the container. The first command does it interactively the second does it via jekyll with an automatic reload
```
docker run -it -p 4000:4000 -v ${PWD}:/site jekyll /bin/bash
```
```
docker run -p 4000:4000 -v ${PWD}:/site jekyll 
```

1. Remember that all pushes to main will end up on github.io and hence `www.nickross.site`


### Some random ruby notes

* Jekyll is the static web site creator
* `bundle` is something like `pip`, but it allows for local/global versions, so kinda like `pyenv`/`npm`. _This is NOT being used here._
* There are only a few `gems` being installed in order to run this, all of them are installed via the `dockerfile` which is probably not good practice but works for this purpose.