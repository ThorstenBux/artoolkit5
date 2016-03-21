set(CPACK_DEBIAN_PACKAGE_NAME ${PROJECT_NAME})

##Add changelog file
# Generate deb change log file
execute_process(COMMAND gzip -9 -c ${CMAKE_CURRENT_SOURCE_DIR}/changelog.Debian
                WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
                OUTPUT_FILE "${PROJECT_BINARY_DIR}/changelog.Debian.gz")


##Preparing the copyright file
#Prepare the DEBIAN copyright header
FILE(STRINGS ${CMAKE_CURRENT_SOURCE_DIR}/copyright_template.txt COPYRIGHT_HEADER NEWLINE_CONSUME)
#Get copyright header and our license text together
string(CONCAT COPYRIGHT_OUT "${COPYRIGHT_HEADER}" "${LICENSE_IN}" "\n\n  .\n On Debian systems, the complete text of the GNU Lesser General Public License can be found in '/usr/share/common-licenses/LGPL-3'")
#Write to file
FILE(WRITE ${PROJECT_BINARY_DIR}/copyright "${COPYRIGHT_OUT}")
#Read file
#SET(CPACK_RESOURCE_FILE_LICENSE "${BUILD_ARTEFACTS_DIR}copyright.txt")    //Does not work so we need to set the file manually
install(FILES ${PROJECT_BINARY_DIR}/copyright DESTINATION /usr/share/doc/${CPACK_DEBIAN_PACKAGE_NAME}/ RENAME copyright PERMISSIONS
        OWNER_WRITE OWNER_READ
        GROUP_READ
        WORLD_READ)
##End copyright file


##control file settings for all deb packages 
SET(CPACK_DEBIAN_PACKAGE_PRIORITY "optional")
set(CPACK_DEBIAN_PACKAGE_HOMEPAGE "http://www.artoolkit.org")
set(CPACK_DEBIAN_PACKAGE_SECTION "devel")
SET(CPACK_DEBIAN_PACKAGE_MAINTAINER "ARToolKit.org <info@artoolkit.org>") #required

## End control file settings


