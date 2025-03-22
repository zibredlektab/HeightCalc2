import 'package:heightcalc/imports.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});
  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Config')),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(15),
          child: ListView(
            children: [
              Center(
                child: Consumer<HeightCalcAppState>(
                  builder: (context, provider, child) {
                    return Column(
                      children: [
                        Text('Heads', style: Theme.of(context).textTheme.headlineSmall!),
                        Gap(20),
                        for (var headItem in provider.heads) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 200),
                            
                            child:
                              HeadListTile(headItem, onChanged: (tripodhead) {
                                if (!headItem.name.contains(tripodhead.name)) {
                                  provider.updateAKSName(provider.heads, headItem.name, tripodhead.name);
                                }
                              }
                            ,)
                            /*Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(headItem.name, style: Theme.of(context).textTheme.titleMedium!),
                                /*SizedBox(
                                  width: 250,
                                  child: TextField(
                                    decoration: InputDecoration(border: OutlineInputBorder(), hintText: headItem.name, helperText: "Head Name",),
                                    autocorrect: false,
                                    onSubmitted: (String? inputValue) {
                                      inputValue ??= headItem.name;
                                      provider.updateAKSName(provider.heads, headItem.name, inputValue);
                                    },
                                  ),
                                ),*/
                                Text('${headItem.height}"'),
                                ElevatedButton.icon(
                                  name: Icon(Icons.edit),
                                  onPressed: null,
                                )
                              ]
                            ),*/
                          ),
                          Gap(20),
                        ],
                      ],
                    );
                  }
                )
              ),
            ],
          ),
        ),
      )
    );
  }
}



class HeadListTile extends StatefulWidget {
  final TripodHead head;
  final Function(TripodHead tripodHead)? onChanged;
  const HeadListTile(this.head, {super.key, this.onChanged});

  @override
  HeadListTileState createState() => HeadListTileState();
}

class HeadListTileState extends State<HeadListTile> {
  bool _editing = false;
  TripodHead _head = TripodHead("", 0);
  TextEditingController _nameEditingController = TextEditingController();
  TextEditingController _heightEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _head = widget.head;
    _editing = false;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: nameWidget,
      subtitle: heightWidget,
      trailing: trailingButton,
    );
  }

  Widget get nameWidget {
    if (_editing) {
    _nameEditingController.text = _head.getName(); 
      return TextField(
        controller: _nameEditingController,
      );
    } else {
      return Text(_head.name);
    }
  }

  Widget get heightWidget {
    if (_editing) {
      _heightEditingController.text = _head.height.toString();
      return TextField(
        controller: _heightEditingController,
      );
    } else {
      return Text(_head.height.toString());
    }
  }

  Widget get trailingButton {
    if (_editing) {
      return IconButton(
        icon: Icon(Icons.check),
        onPressed: _save,
      );
    } else {
      return IconButton(
        icon: Icon(Icons.edit),
        onPressed: _toggleMode,
      );
    }
  }

  void _save() {
    _head.name = _nameEditingController.text;
    _toggleMode();
    if (widget.onChanged != null) {
      widget.onChanged!(_head);
    }
  }

  void _toggleMode() {
    setState(() {
      _editing = !_editing;
    });
  }
}