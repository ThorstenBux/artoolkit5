cmake_minimum_required(VERSION 3.4)
 
PROJECT(artoolkit-lib)

SET(CPACK_GENERATOR "DEB")

##General configuration

if(${CMAKE_SYSTEM_PROCESSOR} STREQUAL "x86_64")
  set(CPACK_DEBIAN_ARCHITECTURE "amd64")
  set(CPACK_RPM_PACKAGE_ARCHITECTURE "x86_64")
else()
  set(CPACK_DEBIAN_ARCHITECTURE "i386")
  set(CPACK_RPM_PACKAGE_ARCHITECTURE "i686")
endif()

if(${CPACK_GENERATOR} STREQUAL "DEB")
  set(ARTKSDK_PACKAGE_ARCH_SUFFIX ${CPACK_DEBIAN_ARCHITECTURE})
elseif(CPACK_GENERATOR STREQUAL "RPM")
  set(ARTKSDK_PACKAGE_ARCH_SUFFIX ${CPACK_RPM_PACKAGE_ARCHITECTURE})
else()
  set(ARTKSDK_PACKAGE_ARCH_SUFFIX ${CMAKE_SYSTEM_PROCESSOR})
endif()

message(STATUS ${ARTKSDK_PACKAGE_ARCH_SUFFIX})

##End configuration




set(ARTK_HOME ../../..)
set(CPACK_DEBIAN_PACKAGE_NAME ${PROJECT_NAME})

set(OUTPUT_DIR /opt/jenkins/artoolkitBuildArtifacts/64bit/)
set(OUTPUT_PREFIX lib)

#TODO: Somehow the CMake build produces an ARWrapper.so file that contains debug information. We do not want that. That is why we strip it here.
execute_process(COMMAND strip -s -o ${OUTPUT_DIR}lib/${OUTPUT_PREFIX}ARWrapper.so ${OUTPUT_DIR}lib/${OUTPUT_PREFIX}ARWrapper.so)

#SETUP directory structure with correct permissions
INSTALL(DIRECTORY DESTINATION /usr DIRECTORY_PERMISSIONS
OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
INSTALL(DIRECTORY DESTINATION /usr/share DIRECTORY_PERMISSIONS
OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
INSTALL(DIRECTORY DESTINATION /usr/share/doc DIRECTORY_PERMISSIONS
OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
INSTALL(DIRECTORY DESTINATION /usr/share/doc/${CPACK_DEBIAN_PACKAGE_NAME} DIRECTORY_PERMISSIONS
OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)

#Include all the libs into the package
INSTALL(DIRECTORY ${OUTPUT_DIR}lib DESTINATION /usr DIRECTORY_PERMISSIONS
OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE 
)

##Preparing the copyright file
#Read license file
FILE(STRINGS ${ARTK_HOME}/LICENSE.txt LICENSE_IN NEWLINE_CONSUME)
#Prepare the DEBIAN copyright header
FILE(STRINGS ${CMAKE_CURRENT_SOURCE_DIR}/copyright_template.txt COPYRIGHT_HEADER NEWLINE_CONSUME)
#Get both together
string(CONCAT COPYRIGHT_OUT "${COPYRIGHT_HEADER}" "${LICENSE_IN}" "\n\n  .\n On Debian systems, the complete text of the GNU Lesser General Public License can be found in '/usr/share/common-licenses/LGPL-3'")
#Write to file
FILE(WRITE ${PROJECT_BINARY_DIR}/copyright "${COPYRIGHT_OUT}")
#Read file
#SET(CPACK_RESOURCE_FILE_LICENSE "${OUTPUT_DIR}copyright.txt")    //Does not work so we need to set the file manually
install(FILES ${PROJECT_BINARY_DIR}/copyright DESTINATION /usr/share/doc/${CPACK_DEBIAN_PACKAGE_NAME}/ RENAME copyright PERMISSIONS
        OWNER_WRITE OWNER_READ
        GROUP_READ
        WORLD_READ)
#End copyright file

##Add changelog file
# Two changelog files are shipped. One that comes with the SDK and one that is in the DEB format to fullfill the DEB package needs.
# Generate required change log files
#Copy ChangeLog.txt to ${PROJECT_BINARY_DIR} because gzip command cannot work with relative paths
file(COPY ${ARTK_HOME}/ChangeLog.txt DESTINATION ${PROJECT_BINARY_DIR})
execute_process(COMMAND gzip -9 -c ${PROJECT_BINARY_DIR}/ChangeLog.txt
                WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
                OUTPUT_FILE "${PROJECT_BINARY_DIR}/changelog.gz")

execute_process(COMMAND gzip -9 -c ${CMAKE_CURRENT_SOURCE_DIR}/changelog.Debian
                WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
                OUTPUT_FILE "${PROJECT_BINARY_DIR}/changelog.Debian.gz")

install(FILES "${PROJECT_BINARY_DIR}/changelog.gz"
              "${PROJECT_BINARY_DIR}/changelog.Debian.gz"
              DESTINATION "/usr/share/doc/${CPACK_DEBIAN_PACKAGE_NAME}")
#INFO: In a regular deb file the changelog and the copyright file go directly into the DEBIAN directory. But that is not supported by CPACK. 
#As we like to provide them we ship them using the /usr/share/doc/ProjectName/ directory.


##According to the packaging guidelines we need a post installation script to call `ldconfig` after installation. This is the case because we install a dynamic library (ARWrapper.so)
#change the postinst file permissions and include them into the package. Permission needs to be 755
file(INSTALL ${CMAKE_CURRENT_SOURCE_DIR}/postinst DESTINATION ${PROJECT_BINARY_DIR} PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
SET(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA ${PROJECT_BINARY_DIR}/postinst;)



##Fill the package control file with the needed information
#Package control file is required and has some important fields that need to be filled.
SET(CPACK_PACKAGE_DESCRIPTION "ARToolKit runtime")
SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY "ARToolKit.org runtime: \n Contains all necessary libraries for ARToolKit to run.\n For more information visit www.ARToolKit.org. \n Fork us on Github https://github.com/artoolkit/artoolkit5")
SET(CPACK_PACKAGE_VENDOR "ARToolKit.org")
SET(CPACK_PACKAGE_CONTACT "info@artoolkit.org")

##Set the ARToolKit SDK version into the controll file
#Fetch the ARToolKit SDK version from the config.h.in file and set it to the corresponding variables
execute_process(COMMAND sed -En -e "s/.*AR_HEADER_VERSION_MAJOR[[:space:]]+([0-9]*).*/\\1/p" ${ARTK_HOME}/include/AR/config.h.in OUTPUT_VARIABLE MAJOR_VERSION)
execute_process(COMMAND sed -En -e "s/.*AR_HEADER_VERSION_MINOR[[:space:]]+([0-9]*).*/\\1/p" ${ARTK_HOME}/include/AR/config.h.in OUTPUT_VARIABLE MINOR_VERSION)
execute_process(COMMAND sed -En -e "s/.*AR_HEADER_VERSION_TINY[[:space:]]+([0-9]*).*/\\1/p" ${ARTK_HOME}/include/AR/config.h.in OUTPUT_VARIABLE PATCH_VERSION)

string(STRIP "${MAJOR_VERSION}" MAJOR_VERSION)
string(STRIP "${MINOR_VERSION}" MINOR_VERSION)
string(STRIP "${PATCH_VERSION}" PATCH_VERSION)

SET(CPACK_PACKAGE_VERSION_MAJOR "${MAJOR_VERSION}")
SET(CPACK_PACKAGE_VERSION_MINOR "${MINOR_VERSION}")
SET(CPACK_PACKAGE_VERSION_PATCH "${PATCH_VERSION}")

message(STATUS "Version: " "${MAJOR_VERSION}" "." "${MINOR_VERSION}" "." "${PATCH_VERSION}")
#End Ser ARToolKit SDK version in controll file

#Name needed dependencies
SET(CPACK_DEBIAN_PACKAGE_DEPENDS "libjpeg-dev, libgstreamer0.10-dev, libv4l-dev, libdc1394-22-dev, libgl1-mesa-dev, freeglut3-dev, libopenscenegraph-dev, libopencv-dev, libc6")
 

SET(CPACK_DEBIAN_PACKAGE_PRIORITY "optional")
set(CPACK_DEBIAN_PACKAGE_HOMEPAGE "http://www.artoolkit.org")
set(CPACK_DEBIAN_PACKAGE_SECTION "devel")
SET(CPACK_DEBIAN_PACKAGE_MAINTAINER "ARToolKit.org <info@artoolkit.org>") #required
## End fill control file


#Set DEB package file name. Needs to be ProjectName_MajorVersion.MinorVersion.PatchVersion_CpuArchitecture
SET(CPACK_PACKAGE_FILE_NAME "${CMAKE_PROJECT_NAME}_${MAJOR_VERSION}.${MINOR_VERSION}.${CPACK_PACKAGE_VERSION_PATCH}_${ARTKSDK_PACKAGE_ARCH_SUFFIX}")

SET(MAKE_ARCHIVE_OUTPUT_DIRECTORY ${OUTPUT_DIR})
INCLUDE(CPack)

#[[

file(GLOB AR_includefiles ${ARTK_HOME}/include/AR/*.h)
file(GLOB AR2_includefiles ${ARTK_HOME}/include/AR2/*.h)
file(GLOB ARWrapper_includefiles ${ARTK_HOME}/include/ARWrapper/*.h)
file(GLOB Eden_includefiles ${ARTK_HOME}/include/Eden/*.h)
file(GLOB KPM1_includefiles ${ARTK_HOME}/include/KPM/*.h)
file(GLOB OpenCV_includefiles ${ARTK_HOME}/include/linux-${ARCHITECTURE}/opencv/*.h)
#TODO: Check openCV2 headers
file(GLOB OpenCV2_includefiles ${ARTK_HOME}/include/linux-${ARCHITECTURE}/opencv2/*.h)
#TODO: Where do these go?
#file(GLOB KPM2_includefiles ${ARTK_HOME}/lib/SRC/KPM/*.h)
#file(GLOB KPMFreak_includefiles ${ARTK_HOME}/lib/SRC/KPM/FreakMatcher/*.h)

#TODO: Goes into another package
INSTALL(FILES ${AR_includefiles} DESTINATION include/AR COMPONENT artoolkit-dev)
INSTALL(FILES ${AR2_includefiles} DESTINATION include/AR2 COMPONENT artoolkit-dev)
INSTALL(FILES ${ARWrapper_includefiles} DESTINATION include/ARWrapper COMPONENT artoolkit-dev)
INSTALL(FILES ${Eden_includefiles} DESTINATION include/AREden COMPONENT artoolkit-dev)
INSTALL(FILES ${KPM1_includefiles} DESTINATION include/KPM COMPONENT artoolkit-dev)
INSTALL(FILES ${OpenCV_includefiles} DESTINATION include/linux-${ARCHITECTURE}/opencv COMPONENT artoolkit-dev)
INSTALL(FILES ${OpenCV2_includefiles} DESTINATION include/linux-${ARCHITECTURE}/opencv2 COMPONENT artoolkit-dev)
#INSTALL(FILES ${KPM2_includefiles} DESTINATION include/AR2 artoolkit-dev)
#INSTALL(FILES ${KPMFreak_includefiles} DESTINATION include/AR2 artoolkit-dev)

]]
