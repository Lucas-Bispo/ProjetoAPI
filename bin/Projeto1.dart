import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
void main() {
menu();// Chamada de função 
}

void menu(){

  print('################# Início #################');
  print('\n Selecione uma das opções abaixo:');
  print('1 - Ver a cotação de hoje');
  print('2 - Registrar a cotação de hoje');//
  print('3 - Ver cotações registradas');

  String option = stdin.readLineSync(); //os dados do teclado como string

  switch(int.parse(option)){//parse converte para interiro
    case 1: today(); break;
    case 2: registerData(); break;
    case 3: listData(); break;
    default : print('\n\nOps, opção inválida. Selecione uma opção válida!\n\n'); menu(); break;
    //caso dê erro chama o menu de novo
  }

}
registerData() async{//pegar dados e colocar em um arquivo
  var hgData = await getData(); //consultar api e jogar os dados em variavel
  dynamic fileData = readFile();//

  fileData = (fileData != null && fileData.length > 0 ? json.decode(fileData) : List());
//condição de verificação de arquivo referente aos dados que foram solicitados, se tiver vazio retorna uma lista 

  bool exists = false;

  fileData.forEach((data) {
    if (data['date'] == now())
      exists = true;  
  });//teste que verifica informação de hoje, se tiver não registra 

  if(!exists){//se não exitir adiciona 
    fileData.add({"date": now(), "data": "${hgData['data']}"});

    Directory dir = Directory.current;//criação de arquivo 
    File file = new File(dir.path + '/meu_artquivo.txt');//carregar arquivo
    RandomAccessFile raf = file.openSync(mode: FileMode.write);//abrir arquivo em modo de escrita

    raf.writeStringSync(json.encode(fileData).toString());//conversão de arquivo
    raf.flushSync();
    raf.closeSync();

    print('\n\n########################### Dados salvos com sucesso!###########################');
  }
  else
  print('\n\n########################### Resgistro não adicionado, já esistente um log financeiro de hoje cadastrado ###########################\n\n');


}

listData() {
  dynamic fileData = readFile();
  fileData = (fileData != null && fileData.length > 0 ? json.decode(fileData) : List());

  print('\n\n################# Listagem dos dados #################');

  fileData.forEach((data) {

  print('${data['date']} -> ${data['data']}');
});

}

today() async{//função pega cotação, 
  var data = await getData();//retorna objeto futuro usasse async
  print('##################################### Hg Brasil - Cotação #####################################');
  print('${data['date']}-> ${data[data]}');

}
//espera a resposta de algo
//no caso desse projeto espera a resposta do site que usaremso no projeto
Future getData() async{ // 
  String url = 'https://api.hgbrasil.com/finance'; //api financeira
  http.Response response = await http.get(url);//espera de requisição de sucesso código
  //de sucesso é o 200

  if(response.statusCode == 200){
    var data = json.decode(response.body)['results']['currencies'];//chamada de função do dart convert
    var usd = data['USD'];
    var eur = data['EUR'];
    var gbp = data['GBP'];
    var ars = data['ARS'];
    var btc = data['BTC'];

    Map formateMap = Map();
    formateMap['date'] = now();
    formateMap['date'] = '${usd['name']}: ${usd['buy']} | ${eur['name']}: ${eur['buy']} | ${gbp['name']}: ${gbp['buy']} | ${ars['name']}: ${ars['buy']} | ${btc['name']}: ${btc['buy']}';
    
    return formateMap;
  }
  else
   throw('Falhou!');
}
String now(){

  var now = DateTime.now();//a função a baixo testa se um caracter ou dois
  return '${now.day.toString().padLeft(2 , '0')}/ ${now.month.toString().padLeft(2 , '0')}/ ${now.year.toString().padLeft(2 , '0')}';
}

String readFile(){//buscar dados no arquivos 
  Directory dir = Directory.current;
  File file = new File(dir.path + '/meu_artquivo.txt');

  if(!file.existsSync()){
    print('Arquivo não encontrado!');
    return null;
  }

  return file.readAsStringSync();
}