import 'package:crm_front/models/city_factory.dart';
import 'package:crm_front/services/note_services.dart';
import 'package:crm_front/views/city_modify.dart';
import 'package:crm_front/views/note_delete.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class CityList extends StatefulWidget {
  const CityList({ Key? key}) : super(key: key);

  @override
  _CityListState createState() => _CityListState();
}

class _CityListState extends State<CityList> {


  List<CityForListing>? cities = [];
  var isLoaded = false;

  @override
  void initState()  {
    super.initState();
    // fetch the cities data from the API
    getData();
  }

  getData() async {
    cities = await FutureCityService().getFutureCitiesList();
    if(cities != null){
      setState(() {
        isLoaded = true;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    // This widget is the home page of your application. It is stateful, meaning
    // that it has a State object (defined below) that contains fields that affect
    // how it looks.

    // This class is the configuration for the state. It holds the values (in this
    // case the title) provided by the parent (in this case the App widget) and
    // used by the build method of the State. Fields in a Widget subclass are
    // always marked "final".


    return Scaffold(
      appBar: AppBar(
        title: const Text(' List of Cities'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => CityModify()));
        },
        child: Icon(Icons.add),
      ),
      body: Visibility(
        visible: isLoaded,
        child: ListView.builder(
          itemCount: cities?.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: ValueKey(cities?[index].id),
              direction: DismissDirection.startToEnd,
              onDismissed: (direction){},
              confirmDismiss: (direction) async{
                final result = await showDialog(
                    context: context,
                    builder: (context) => NoteDelete()
                );
                return result;
              },
              background: Container(
                  color: Colors.red,
                  padding: EdgeInsets.only(left: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                        Icons.delete,
                        color: Colors.white
                    ),
                  )
              ),
              child: ListTile(
                leading: Icon(Icons.location_city),
                title: Text(cities![index].id.toString()),
                subtitle: Text(cities![index].name),
                isThreeLine: true,
                trailing: Icon(Icons.more_vert),
                onTap: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => CityModify(
                              cityID: cities?[index].id
                          )
                      )
                  );
                },
              ),
            );
          },
        ),
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      
    );
  }
}
