cp $RECIPE_DIR/make.inc .
cp $RECIPE_DIR/makefile ./SRC/.

cd SRC/
make single_double_complex_dcomplex

cd ../

mkdir -p $PREFIX/include
mkdir -p $PREFIX/lib

if [[ "$target_platform" == linux-* ]]; then
  $FC -shared -o liblapack95.so $LDFLAGS -Wl,--whole-archive lapack95.a -Wl,--no-whole-archive $PREFIX/lib/liblapack.so $PREFIX/lib/libblas.so
elif [[ "$target_platform" == osx-* ]]; then
  $FC -shared -o liblapack95.dylib $LDFLAGS -Wl,-undefined -Wl,dynamic_lookup -Wl,-all_load lapack95.a -Wl,-noall_load $PREFIX/lib/liblapack.dylib $PREFIX/lib/libblas.dylib
fi

cp lapack95.a $PREFIX/lib/.
cp liblapack95$SHLIB_EXT $PREFIX/lib/liblapack95$SHLIB_EXT
cp lapack95_modules/*.mod $PREFIX/include/

cd $PREFIX/include/
ln -s f95_lapack.mod lapack95.mod
