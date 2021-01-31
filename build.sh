echo -e "\nStarting compilation...\n"
# ENV
CONFIG=vendor/sixteen_defconfig
KERNEL_DIR=$(pwd)
PARENT_DIR="$(dirname "$KERNEL_DIR")"
KERN_IMG="$KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb"
export KBUILD_BUILD_USER="elang"
export KBUILD_BUILD_HOST="kyvangkaelang"
export PATH="/home/kyvangka1610/toolchain/Clang12/bin:$PATH"
export LD_LIBRARY_PATH="/home/kyvangka1610/toolchain/Clang12/lib:$LD_LIBRARY_PATH"
export KBUILD_COMPILER_STRING="$(/home/kyvangka1610/toolchain/Clang12/bin/clang --version | head -n 1 | perl -pe 's/\((?:http|git).*?\)//gs' | sed -e 's/  */ /g' -e 's/[[:space:]]*$//' -e 's/^.*clang/clang/')"
export CROSS_COMPILE=/home/kyvangka1610/toolchain/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export CROSS_COMPILE_ARM32=/home/kyvangka1610/toolchain/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-
export out=/home/kyvangka1610/out-new-Q

# Functions
clang_build () {
    make -j4 O=$out \
                          ARCH=arm64 \
                          CC="clang" \
                          AR="llvm-ar" \
                          NM="llvm-nm" \
			   LD="ld.lld" \
			   AS="llvm-as" \
			   OBJCOPY="llvm-objcopy" \
			   OBJDUMP="llvm-objdump" \
                          CLANG_TRIPLE=aarch64-linux-gnu- \
                          CROSS_COMPILE=$CROSS_COMPILE \
                          CROSS_COMPILE_ARM32=$CROSS_COMPILE_ARM32
}

# Build kernel
make O=$out ARCH=arm64 $CONFIG > /dev/null
echo -e "${bold}Compiling with CLANG${normal}\n$KBUILD_COMPILER_STRING"
clang_build
echo -e "\nCompleted in $((SECONDS / 60)) minute(s) and $((SECONDS % 60)) second(s) !"
