class Grape::API

  # permission_denied
  NOT_GOD_DENIED = 'not GOD, permission denied.'
  NOT_GOD_OA_DENIED = 'not GOD, not OA, permission denied.'
  NOT_GOD_OA_MEMBER_DENIED = 'not GOD, not OA, not member, permission denied.'
  NOT_INVENTOR_DENIED = 'not INVENTOR, permission denied.'
  NOT_CO_INVENTOR_DENIED = 'not CO-INVENTOR, permission denied.'
  NOT_GOD_INVENTOR_DENIED = 'not GOD, not INVENTOR, permission denied.'
  NOT_ORG_USR_DENIED = 'not organization user, permission denied.'
  NOT_GOD_AUTH_DENIED = 'not GOD, not Auth, permission denied.'

  INACTIVE_USER_DENIED = 'inactive in organization, permission denied.'

  # data_not_found
  MISSING_CONCEPT = 'no concept found'
  MISSING_ORG = 'no organization found.'
  MISSING_INV = 'no invention found.'
  MISSING_ORG_USR = 'no organization user found.'
  MISSING_INV_USR = 'no invention user found.'
  MISSING_USR = 'no user found.'
  MISSING_ROL = 'no role found.'
  MISSING_USR_ORG = 'no user organization found.'
  MISSING_USR_INV = 'no user invention found.'
  MISSING_USR_ROL = 'no user role found.'
  MISSING_ADDRESS = 'no address found.'
  MISSING_PHONE = 'no phone found.'
  MISSING_FILE = 'no file found.'
  MISSING_IO = 'no invention opportunity found.'
  MISSING_COMMENT = 'no comment found.'
  MISSING_SEARCH = 'no search found.'
  MISSING_SCRATCHPAD = 'no scratchpad found.'
  MISSING_CS = 'no container section found.'
  # data_exist
  EXIST_INV_SCRATCHPAD = 'invention scratchpad already exist.'
  EXIST_ROL = 'role name already exist.'
  EXIST_ORG = 'organization name already exist.'
  EXIST_IO_TITLE = 'invention opportunity title already exist.'
  # unknown attribute name
  UNKNOWN_ATTRIBUTE_NAME = 'unknown attribute name'

end
