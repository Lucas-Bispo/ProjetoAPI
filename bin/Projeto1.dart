import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
void main() {
menu();
}

void menu(){

  print('################# Início #################');
  print('\n Selecione uma das opções abaixo:');
  print('1 - Ver a cotação de hoje');
  print('2 - Registrar a cotação de hoje');


  String option = stdin.readLineSync();

  switch(int.parse(option)){
    case 1: today(); break;
    case 2: registerData(); break;
    default : print('\n\nOps, opção inválida. Selecione uma opção válida!\n\n'); menu(); break;
  }

}

registerData() async{
  var hgData = await getData();
  dynamic fileData = readFile();

  fileData = (fileData != null && fileData.length > 0 ? json.decode(fileData) : List());

  bool exists = false;

  fileData.forEach((data) {
    if (data['date'] == now())
      exists = true;  
  });

  if(!exists){
    fileData.add({"date": now(), "data": "${hgData['data']}"});

    Directory dir = Directory.current;
    File file = new File(dir.path + '/meu_artquivo.txt');
    RandomAccessFile raf = file.openSync(mode: FileMode.write);

    raf.writeStringSync(json.encode(fileData).toString());
    raf.flushSync();
    raf.closeSync();

    print('\n\n########################### Dados salvos com sucesso!###########################');
  }
  else
  print('\n\n########################### Resgistro não adicionado, já esistente um log financeiro de hoje cadastrado ###########################\n\n');


}

today() async{
  var data = await getData();
  print('##################################### Hg Brasil - Coleção #####################################');
  print('${data['date']}-> ${data[data]}');

}
//espera a resposta de algo
//no caso desse projeto espera a resposta do site que usaremso no projeto
Future getData() async{
  String url = 'https://api.hgbrasil.com/finance';
  http.Response response = await http.get(url);

  if(response.statusCode == 200){
    var data = json.decode(response.body)['results']['currencies'];
    var usd = data['USD'];
    var eur = data['EUR'];
    var gbp = data['GBP'];
    var ars = data['ARS'];
    var btc = data['BTC'];

    Map formateMap = Map();
    formateMap['date'] = '25/01/2019'; //now();
    formateMap['date'] = '${usd['name']}: ${usd['buy']} | ${eur['name']}: ${eur['buy']} | ${gbp['name']}: ${gbp['buy']} | ${ars['name']}: ${ars['buy']} | ${btc['name']}: ${btc['buy']}';
    
    return formateMap;
  }
  else
   throw('Falhou!');
}
String now(){

  var now = DateTime.now();
  return '${now.day.toString().padLeft(2 , '0')}/ ${now.month.toString().padLeft(2 , '0')}/ ${now.year.toString().padLeft(2 , '0')}';
}

String readFile(){
  Directory dir = Directory.current;
  File file = new File(dir.path + '/meu_artquivo.txt');

  if(!file.existsSync()){
    print('Arquivo não encontrado!');
    return null;
  }

  return file.readAsStringSync();
}