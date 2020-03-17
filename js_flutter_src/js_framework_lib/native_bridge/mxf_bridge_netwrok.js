'use strict';
const dart_sdk = require("dart_sdk");
const convert = dart_sdk.convert;


class MXFNetworking {
  constructor() {

  }

  sendRequest(
    { method, //: string,
      url,    //: string,
      data,   //Object,
      headers,// Object,
      responseType, // : Object, // TODO: Use stricter type.
      incrementalUpdates,//: boolean,
      timeout,
      withCredentials,// boolean,
      trackingName,  //: string,
      //
      onCreateRequest,   // fun(requestID){}
      onReceiveResponse, //status: number,responseHeaders: ?Object,responseURL: ?string,
      onCompleteResponse,  //* all in one: onCompleteResponse(status, respHeaders,responseType, responseData, errorDesc, isTimeOut);
      onReceiveIncrementalData,
      onReceiveDataProgress,
      onUploadProgress,  // fun(requestId: number,progress: number,total: number,)
    }
  ) {

    let body = data;
    let origResponseType = responseType;
    responseType = this.getNativeResponseType(responseType);

    MXNativeJSFlutterApp.networking.sendRequest(
      {
        method,
        url,
        data: { ...body, trackingName },
        headers,
        responseType,
        incrementalUpdates,
        timeout,
        withCredentials,
      },
      function (eventName, args) {

        if (eventName == "didReceiveRequestID") {

          let requestID = args[0];
          if (onCreateRequest != null) onCreateRequest(requestID);

        } else if (eventName == "didReceiveNetworkResponse") {

          //@[task.requestID, @(status), headers, responseURL];
          let status = args[1];
          let respHeaders = args[2];
          let responseURL = args[3];
          if (onReceiveResponse != null) onReceiveResponse(status, respHeaders, responseURL);

        } else if (eventName == "didSendNetworkData") {

          //[task.requestID, @((double)progress), @((double)total)];
          let progress = args[1];
          let total = args[2];

          if (onUploadProgress != null) onUploadProgress(progress, total);

        } else if (eventName == "didReceiveNetworkIncrementalData") {

          // @[task.requestID,
          //   responseString,
          //   @(progress + initialCarryLength - incrementalDataCarry.length),
          //   @(total)];
          let responseString = args[1];
          let progress = args[2];
          let total = args[3];

          if (onReceiveIncrementalData != null) onReceiveIncrementalData(responseString, progress, total);

        } else if (eventName == "didReceiveNetworkDataProgress") {

          let progress = args[1];
          let total = args[2];
          if (onReceiveDataProgress != null) onReceiveDataProgress(progress, total);
        } else if (eventName == "didCompleteNetworkResponse") {

          // @[task.requestID,
          //   responseData?:@"",
          //   MXNullIfNil(error.localizedDescription),
          //   error.code == kCFURLErrorTimedOut ? @YES : @NO];

          let status = args[1];
          let respHeaders = args[2];

          let responseData = args[3];
          let errorDesc = args[4];
          let isTimeOut = args[5];

          if (origResponseType === 'arraybuffer') {
            responseData = convert.base64Decode(responseData);
          }

          if (onCompleteResponse != null) onCompleteResponse(status, respHeaders,origResponseType, responseData, errorDesc, isTimeOut);

        }

      }.bind(this),
    );
  }

  abortRequest(requestId) {
    MXNativeJSFlutterApp.networking.abortRequest(requestId);
  }

  clearCookies(callback) {
    MXNativeJSFlutterApp.networking.clearCookies(callback);
  }

  getNativeResponseType(responseType) {

    let nativeResponseType = responseType;

    if (responseType == null) {
      nativeResponseType = 'text';
    } else if (responseType === 'arraybuffer') {
      nativeResponseType = 'base64';
    }
    else if (responseType === 'blob') {
      nativeResponseType = 'base64'; //暂不支持
    }

    return nativeResponseType;

  }
}

exports.network = new MXFNetworking;
