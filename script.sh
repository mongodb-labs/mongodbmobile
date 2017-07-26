set -e

# make a repo for this all to go in
if [ ! -d "cross-built-mongo" ]; then
    mkdir cross-built-mongo
fi
cd cross-built-mongo

# get the mongo repo
if [ ! -d "mongo" ]; then
    git clone https://github.com/mongodb/mongo.git
fi

# get the c driver and open it
CDRIVER_VERSION=1.6.3
if [ ! -d "mongo-c-driver" ]; then
    curl -LO https://github.com/mongodb/mongo-c-driver/releases/download/$CDRIVER_VERSION/mongo-c-driver-$CDRIVER_VERSION.tar.gz
    tar xzf mongo-c-driver-$CDRIVER_VERSION.tar.gz
    mv mongo-c-driver-$CDRIVER_VERSION mongo-c-driver
    rm -rf mongo-c-driver-$CDRIVER_VERSION
fi
cd mongo-c-driver

# configure, make, and install the cdriver
./configure --prefix=$(pwd)/install --build x86_64-apple-darwin16.6.0 --host arm-apple-darwin --with-libbson=bundled --disable-automatic-init-and-cleanup --disable-ssl --disable-sasl --disable-examples --disable-man-pages --disable-html-docs --disable-shm-counters --disable-shared --enable-static CC="$(xcrun -f --sdk iphoneos clang)" CXX="$(xcrun -f --sdk iphoneos clang++)" CPPFLAGS="-isysroot $(xcrun --sdk iphoneos --show-sdk-path) -miphoneos-version-min=10.2 -arch arm64 -fembed-bitcode"  CFLAGS="-isysroot $(xcrun --sdk iphoneos --show-sdk-path) -miphoneos-version-min=10.2 -arch arm64 -fembed-bitcode" CXXFLAGS="-isysroot $(xcrun --sdk iphoneos --show-sdk-path) -miphoneos-version-min=10.2 -arch arm64 -fembed-bitcode" LDFLAGS="-miphoneos-version-min=10.2 -arch arm64"
make -j8
make install

# grab the library paths necessary for cross compilation
pwd=$(pwd)
LIBBSON_DIR="$pwd/install/include/libbson-1.0"
LIBMONGOC_DIR="$pwd/install/include/libmongoc-1.0"
LIBPATH_DIR="$pwd/install/lib"

# cross compile mongo with the cdriver
cd ..
cd mongo
scons -j16 --dbg=on --disable-warnings-as-errors --js-engine=none --variables-files=etc/scons/xcode_ios.vars --mmapv1=off CPPPATH="$LIBBSON_DIR $LIBMONGOC_DIR" LIBPATH=$LIBPATH_DIR embedded_capi
pwd=$(pwd)
MONGO_DIR="$pwd/src"
MONGO_EMBEDDED_DIR="$pwd/src/mongo/client/embedded"
cd ..

# make a directory to put all object files in
if [ -d "objfiles" ]; then
    rm -rf objfiles
fi

mkdir objfiles
cd objfiles
OBJ_FILES=$(pwd)
cd ..


# recursivily find relative paths to all nessecary object files
find mongo/build/debug -name "*.a" | while read f; do
# generate new file name replacing all '/' with '_' to generate unique names
g=$(echo $f | tr / _)
cp $f "objfiles/${g}"
done
cp mongo-c-driver/install/lib/libbson-1.0.a objfiles
cp mongo-c-driver/install/lib/libmongoc-1.0.a objfiles

echo "XCode Installation Instructions:"
echo "Step 1: Go to the Build Phases Tab and add all of the .a files in the object files path into the Link With Libraries section"
echo "Step 2: Go to the Build Settings Tab and hit all at the top"
echo "Step 3: Set the variable 'always search user paths' to true"
echo "Step 4: Under linker flags add the following two flags: '-all_load' and '-lstdc++'"
echo "Step 5: Navigate to Header Search Paths section and add the following links: (all non-recursively)"
echo "        $LIBBSON_DIR"
echo "        $LIBMONGOC_DIR"
echo "        $MONGO_DIR"
echo "        $MONGO_EMBEDDED_DIR"
echo "Step 6: Navigate to Library Search Paths section and add the following links: (all non-recursively)"
echo "        $OBJ_FILES"
echo "        $LIBPATH_DIR"



