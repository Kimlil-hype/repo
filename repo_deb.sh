#!/bin/sh
 
 # password for DEB-GPG-KEY
 key_pass="Neon14328"

_soft1=soft/binary-i386
_soft2=soft/binary-x86_64
p_soft1=dists/nobody/soft/binary-i386/Packages
p_soft2=dists/nobody/soft/binary-x86_64/Packages

# i386
dpkg-scanpackages -m pool/soft > $p_soft1
cat $p_soft1 | gzip -9c > $p_soft1.gz
cat $p_soft1 | bzip2 -9 > $p_soft1.bz2

# x86_64
dpkg-scanpackages -m pool/soft > $p_soft2
cat $p_soft2 | gzip -9c > $p_soft2.gz
cat $p_soft2 | bzip2 -9 > $p_soft2.bz2

cd dists/nobody

# Create the Repositary Release file

cat > Release << END
Origin: nobody
Label: nobody repo
Suite: nobody
Codename: nobody
Version: 1.0
Architectures: i386
Components: soft
Description: nobody 1.0 repo
MD5Sum:
END

# Create Relases

cd $_soft1
cat > Release << END
Archive: nobody
Version: 1.0
Component: soft
Origin: nobody
Label: nobody packages
Architecture: i386
Description: nobody 1.0 repo
END

cd ../../$_soft2
cat > Release << END
Archive: nobody
Version: 1.0
Component: soft
Origin: nobody
Label: nobody packages
Architecture: x86_64
Description: nobody 1.0 repo
END

cd ../..

# MD5Sum Calculate for all files

# i386

md5sum=$(md5sum "$_soft1/Packages" | cut -d ' ' -f1)
sizeinbytes=$(ls -l "$_soft1/Packages" | cut -d ' ' -f5)
printf " "$md5sum" %1d $_soft1/Packages" $sizeinbytes >> Release
printf "\n" >> Release
md5sum=$(md5sum "$_soft1/Packages.bz2" | cut -d ' ' -f1)
sizeinbytes=$(ls -l "$_soft1/Packages.bz2" | cut -d ' ' -f5)
printf " "$md5sum" %1d $_soft1/Packages.bz2" $sizeinbytes >> Release
printf "\n" >> Release
md5sum=$(md5sum "$_soft1/Packages.gz" | cut -d ' ' -f1)
sizeinbytes=$(ls -l "$_soft1/Packages.gz" | cut -d ' ' -f5)
printf " "$md5sum" %1d $_soft1/Packages.gz" $sizeinbytes >> Release
printf "\n" >> Release
md5sum=$(md5sum "$_soft1/Release" | cut -d ' ' -f1)
sizeinbytes=$(ls -l "$_soft1/Release" | cut -d ' ' -f5)
printf " "$md5sum" %1d $_soft1/Release" $sizeinbytes >> Release
printf "\n" >> Release

# x86_64

md5sum=$(md5sum "$_soft2/Packages" | cut -d ' ' -f1)
sizeinbytes=$(ls -l "$_soft2/Packages" | cut -d ' ' -f5)
printf " "$md5sum" %1d $_soft2/Packages" $sizeinbytes >> Release
printf "\n" >> Release

md5sum=$(md5sum "$_soft2/Packages.bz2" | cut -d ' ' -f1)
sizeinbytes=$(ls -l "$_soft2/Packages.bz2" | cut -d ' ' -f5)
printf " "$md5sum" %1d $_soft2/Packages.bz2" $sizeinbytes >> Release
printf "\n" >> Release

md5sum=$(md5sum "$_soft2/Packages.gz" | cut -d ' ' -f1)
sizeinbytes=$(ls -l "$_soft2/Packages.gz" | cut -d ' ' -f5)
printf " "$md5sum" %1d $_soft2/Packages.gz" $sizeinbytes >> Release
printf "\n" >> Release

md5sum=$(md5sum "$_soft2/Release" | cut -d ' ' -f1)
sizeinbytes=$(ls -l "$_soft2/Release" | cut -d ' ' -f5)
printf " "$md5sum" %1d $_soft2/Release" $sizeinbytes >> Release
printf "\n" >> Release

# Signing all files

printf "\n* Singning Repositary *\n"
echo $key_pass | gpg --yes --no-use-agent --passphrase-fd 0 -bao Release.gpg Release

printf "\n* Singning i386 *\n"
cd $_soft1
echo $key_pass | gpg --yes --no-use-agent --passphrase-fd 0 -bao Release.gpg Release

printf "\n* Singning x86_64 *\n"
cd ../../$_soft2
echo $key_pass | gpg --yes --no-use-agent --passphrase-fd 0 -bao Release.gpg Release
