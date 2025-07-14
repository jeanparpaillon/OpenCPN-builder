build_base = $(PWD)/build
target = android_armhf

opencpn_vsn = $(shell git submodule status opencpn | awk -e '{ print $$ 1 }')
apk_vsn = $(shell git describe --always)
android_img_vsn = 2023.12-ndk

build_dir = $(build_base)/opencpn_$(opencpn_vsn)
libgorp = $(build_dir)/libgorp.so

all: $(libgorp)

$(libgorp): | $(build_dir)
	rm -rf $(build_dir)/tmp && install -m 777 -d $(build_dir)/tmp
	docker run \
	  --rm \
	  -v $(PWD)/opencpn:/home/circleci/project \
	  -v $(PWD)/scripts:/scripts \
	  -v $(build_dir)/tmp:/build \
	  -e OCPN_TARGET=$(target) \
	  -e BUILD_DIR=$(build_dir)/tmp \
	  cimg/android:$(android_img_vsn) \
	  /scripts/build-corelibs-$(target).sh
	cp $(build_dir)/tmp/libgorp.so $(build_dir)/libgorp.so

$(build_dir):
	mkdir -p $@

.PHONY: all
