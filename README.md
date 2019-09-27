# Generic-purpose GNU Make setup
This is my generic-purpose GNU make setup. It was written to use with various tutorials, but I've used for other types of projects as well.

## Assumptions:
### Expected structure of the source code:
```
Makefile
build_include.mk
build_auto_dep.mk
src/
  /<name1>/
      <name1>.cpp
      <name1-includes-and-other-whatnots>
  /<name2>/
      <name2>.c
      <name2-includes-and-other-whatnots>
...
  /<nameN>/
      <nameN>.cpp
      <nameN-includes-and-other-whatnots>
```
NOTE: dirnames and basename of the file which contains "main" must be the same.

### Produced output:
```
out/
  /<name1>/<name1> (name1 is executable)
  /<name2>/<name2> (name2 is executable)
...
  /<nameN>/<nameN> (nameN is executable)
```
