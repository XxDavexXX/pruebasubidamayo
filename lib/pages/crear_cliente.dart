import 'package:flutter/material.dart';
import '../services/helper.dart';
import '../services/db.dart';
import '../services/hive_helper.dart';
import '../widgets/default_background.dart';
import '../widgets/simple_white_box.dart';
import '../widgets/editable_data.dart';
import '../widgets/dialog_title.dart';
import '../widgets/simple_line.dart';
import '../widgets/my_icon.dart';
import '../widgets/button.dart';
import '../widgets/input.dart';
import '../widgets/div.dart';
import '../widgets/p.dart';

class CrearCliente extends StatefulWidget {
  const CrearCliente({super.key});
  @override
  State<CrearCliente> createState() => _CrearClienteState();
}

class _CrearClienteState extends State<CrearCliente> {

  //E.g.: {'id': 111,'nombre': 'Manuel Gomez','documento': 'DNI','nroDeDocumento': '64826459','direccion': 'Address 123','correo': 'manu23g@hotmail.com','telefono': '9993472446'}

  late final TextEditingController _nombre;
  String _documento = 'DNI';
  late final TextEditingController _nroDeDocumento;
  late final TextEditingController _direccion;
  late final TextEditingController _correo;
  late final TextEditingController _telefono;
    
  @override
  void initState(){
    super.initState();
    _nombre = TextEditingController();
    _nroDeDocumento = TextEditingController();
    _direccion = TextEditingController();
    _correo = TextEditingController();
    _telefono = TextEditingController();
  }

  @override
  void dispose(){
    _nombre.dispose();
    _nroDeDocumento.dispose();
    _direccion.dispose();
    _correo.dispose();
    _telefono.dispose();
    super.dispose();
  }

  void _editDocumento()async{
    List<String> opts = ['DNI','RUC','Carnet de extranjería','Pasaporte'];
    int? opt = await choose(context,opts,text:'Documento:');
    if(opt==null)return;
    setState(()=>_documento=opts[opt!]);
  }

  void _crearNuevoCliente()async{
    String nombre = _nombre.text.trim();
    String nroDeDocumento = _nroDeDocumento.text.trim();
    String direccion = _direccion.text.trim();
    String correo = _correo.text.trim();
    String telefono = _telefono.text.trim();
    if(nombre.length == 0){alert(context,'Completar:\nNombre');return;}
    if(nroDeDocumento.length == 0){alert(context,'Completar:\nNúmero de documento');return;}
    if(_documento != 'DNI'){//Al usar DNI, no se debe de exigir dirección
      if(direccion.length == 0){alert(context,'Completar:\nDireccion');return;}
    }
    if((await confirm(context,'¿Crear cliente?'))!=true)return;
    loadThis(context,()async{
      await addClient({
        'nombre': nombre,
        'documento': _documento,
        'nroDeDocumento': nroDeDocumento,
        'direccion': direccion,
        'correo': correo,
        'telefono': telefono,
      });
      back(context);
    });
  }

  int? _getNroDeDocumentoMaxChars(){
    switch(_documento){
      case 'DNI': return 8;
      case 'RUC': return 11;
      default: return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    	backgroundColor:Theme.of(context).colorScheme.surface,
    	appBar: AppBar(
        actions: [
          MyIcon(Icons.arrow_back,()=>back(context)),sep,
        ],
      ),
      body: DefaultBackground(
        addPadding: true,
        child: Column(
          children: [
            SimpleWhiteBox(
              children: [
                DialogTitle('Crear cliente'),
                sep,
                P('Nombre:',color:Colors.black),
                Input(_nombre,hint: 'Nombre',capitalization:TextCapitalization.words),sep,
                EditableData('Tipo de documento:',_documento,_editDocumento),sep,
                P('Número de documento:',color:Colors.black),
                Input(_nroDeDocumento,hint: 'Nro de documento',maxCharacters:_getNroDeDocumentoMaxChars()),sep,
                P('Dirección:',color:Colors.black),
                Input(_direccion,hint: 'Direccion'),sep,
                P('Correo:',color:Colors.black),
                Input(_correo,hint: 'Correo',type:TextInputType.emailAddress),sep,
                P('Teléfono:',color:Colors.black),
                Input(_telefono,hint: 'Telefono',type:TextInputType.phone),sep,
                sep,sep,
                Button(P('Crear usuario'),_crearNuevoCliente),
                sep,
              ],
            ),
          ],
        ),
      ),
    );
  }
}