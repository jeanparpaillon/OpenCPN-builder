build_base = $(PWD)/build
target = android_armhf
ocpn_android_core_build_support = opencpn/cache/OCPNAndroidCoreBuildSupport
ocpn_android_core_build_support_url = https://github.com/bdbcat/OCPNAndroidCoreBuildSupport/releases/download/v1.2/OCPNAndroidCoreBuildSupport.zip
ocpn_android_core_build_support_archive = cache/OCPNAndroidCoreBuildSupport-1.2.zip
ocpn_android_core_build_support_sha256sum = c4110c532e9a0bcf071bbd10fe6f7627d7e91380c803c52ac0e89ce5f993db9b

opencpn_vsn = $(shell git submodule status opencpn | awk -e '{ print $$ 1 }')
apk_vsn = $(shell git describe --always)
android_img_vsn = 2023.12-ndk

build_dir = $(build_base)/opencpn_$(opencpn_vsn)
libgorp_android_armhf = $(build_dir)/$(target)/libgorp.so

all: $(libgorp_android_armhf)

$(libgorp_android_armhf): | $(ocpn_android_core_build_support) $(build_dir) builder_android_armhf
	rm -rf $(@D) && \
		mkdir -p $(@D) && \
		mkdir -p $(@D)/tmp
	docker run \
	  --rm \
	  -v $(PWD)/opencpn:/src \
	  -v $(@D)/tmp:/build \
	  -e OCPN_TARGET=$(target) \
	  -e SRC_DIR=/src \
	  -e BUILD_DIR=/build \
	  builder_android_armhf
	mv $(@D)/tmp/libgorp.so $@
	rm -rf $(@D)/tmp

$(ocpn_android_core_build_support): $(ocpn_android_core_build_support_archive)
	rm -rf $@ && mkdir -p $(@D)
	cd $(@D) && unzip $(realpath $<) > /dev/null

$(ocpn_android_core_build_support_archive):
	wget -O $@ https://github.com/bdbcat/OCPNAndroidCoreBuildSupport/releases/download/v1.2/OCPNAndroidCoreBuildSupport.zip
	sha256sum -c $(patsubst %.zip,%.sum,$@) > /dev/null

builder_android_armhf:
	cd docker && \
	  docker build \
	    --target $@ \
	    --tag $@ \
	    --build-arg UID=$(shell id -u) \
	    --build-arg GID=$(shell id -g) \
	    .

$(build_dir):
	mkdir -p $@

.PHONY: all builder_android_armhf
