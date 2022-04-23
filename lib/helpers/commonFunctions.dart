import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:test_flutter/models/ServerResponse.dart';

String generateMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}

Future<ServerResponse>getData(String url) async{
  ServerResponse serverResponse;
  try{

    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    HttpClientResponse response = await request.close();

    if(response.statusCode == 200) {
      String reply = await response.transform(utf8.decoder).join();
      serverResponse = new ServerResponse(true, reply);
      return serverResponse;
    }else{
      String reply = await response.statusCode.toString();
      String error = await response.transform(utf8.decoder).join();
      var myresponse = jsonDecode(error);
      reply += " " + myresponse['error'];
      print("Error ${reply}");
      serverResponse = new ServerResponse(false, reply);
      return serverResponse;
    }
  } catch(Exception){
    print(Exception);
    serverResponse = new ServerResponse(false, Exception.toString());
    return serverResponse;
  }
}