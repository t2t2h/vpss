TARGET := iphone:clang:latest:14.0
ARCHS := arm64 arm64e
DEBUG := 0
FINALPACKAGE := 1

include $(THEOS)/makefiles/common.mk

LIBRARY_NAME := AflatoonCore
AflatoonCore_FILES := AflatoonCore.m APSettings.m APPanel.m
AflatoonCore_CFLAGS := -fobjc-arc -Wall -Wextra -Wno-deprecated-declarations
AflatoonCore_FRAMEWORKS := UIKit Foundation QuartzCore
AflatoonCore_INSTALL_PATH := @executable_path/Frameworks

include $(THEOS_MAKE_PATH)/library.mk
