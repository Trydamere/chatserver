set -x

if [ ! -d "build/" ]; then
   mkdir build/
fi

if [ ! -d "bin/" ]; then
   mkdir bin/
fi

rm -rf build/*
cd build &&
cmake .. &&
make