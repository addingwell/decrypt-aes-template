___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Decrypt AES",
  "description": "",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "toBeDecrypted",
    "displayName": "To be decrypted",
    "simpleValueType": true
  },
  {
    "type": "TEXT",
    "name": "iv",
    "displayName": "IV",
    "simpleValueType": true
  },
  {
    "type": "TEXT",
    "name": "key",
    "displayName": "Key",
    "simpleValueType": true
  }
]


___SANDBOXED_JS_FOR_SERVER___

const Promise = require("Promise");
const sendHttpRequest = require('sendHttpRequest');
const getRequestHeader = require('getRequestHeader');
const JSON = require('JSON');
const logToConsole = require("logToConsole");
const host = getRequestHeader('host');

const toBeDecrypted = data.toBeDecrypted;
const key = data.key;
const iv = data.iv;

if (!toBeDecrypted) {
  return toBeDecrypted;
}

return decrypt(toBeDecrypted);

function decrypt(value) {
  let requestBody = { 
    "mode":"cbc",
    "cypherText": value,
    "cypherTextEncoding":"base64",
    "key": key,
    "iv": iv,
    "keyEncoding": "utf-8",
    "keySize": 256
  };

  return sendHttpRequest('https://' + host + '/transformer/aes-decrypt',
    {
      headers: {
        'Content-Type': 'application/json',
      },
      method: 'POST',
    }, JSON.stringify(requestBody))
    .then((result) => {
      const statusCode = result.statusCode;
      const body = result.body;
      if (statusCode >= 200 && statusCode < 300) {
        const bodyParsed = JSON.parse(body);
        return bodyParsed.message;
      } else {
        return null;
      }
    }
  );
}


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "read_request",
        "versionId": "1"
      },
      "param": [
        {
          "key": "headerWhitelist",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "host"
                  }
                ]
              }
            ]
          }
        },
        {
          "key": "headersAllowed",
          "value": {
            "type": 8,
            "boolean": true
          }
        },
        {
          "key": "requestAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "headerAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "queryParameterAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "send_http",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedUrls",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 17/04/2026, 16:55:23


