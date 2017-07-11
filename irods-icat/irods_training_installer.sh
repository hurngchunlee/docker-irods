#!/bin/bash

## download the irods_training from github
branch='master'

wget https://github.com/irods/irods_training/archive/${branch}.zip

unzip ${branch}.zip

mkdir -p irods_training-${branch}/advanced/landing_zone_microservices/build

cwd=$(pwd)

cd irods_training-${branch}/advanced/landing_zone_microservices/build \
&& /opt/irods-externals/cmake3.5.2-0/bin/cmake .. \
&& make package \
&& rpm -ivh irods-landing-zone-example-*.rpm

cd ${cwd}

cat <<EOF >> /etc/irods/metadata.re
acPostProcForPut {
    if ($filePath like "*.jpg" || $filePath like "*.jpeg" || $filePath like "*.bmp" ||
        $filePath like "*.tif" || $filePath like "*.tiff" || $filePath like "*.rif" ||
        $filePath like "*.gif" || $filePath like "*.png"  || $filePath like "*.svg" ||
        $filePath like "*.xpm") {
        msiget_image_meta($filePath, *meta);
        msiString2KeyValPair(*meta, *meta_kvp);
        msiAssociateKeyValuePairsToObj(*meta_kvp, $objPath, "-d");
    }
}
EOF
