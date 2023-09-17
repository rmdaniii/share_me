import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const ShareMe());
}

class ShareMe extends StatelessWidget {
  const ShareMe({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String text = '';
  String subject = '';
  List<String> imagePaths = [];

  @override
  Widget build(BuildContext context) {
    String pickedFile = imagePaths == null ? "" : imagePaths.toString();
    String trimmedFileName = pickedFile.split("/").last;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[100],
        title: const Text(
          'ShareMe Data',
          style: TextStyle(color: Colors.blue),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Share text:',
                  labelStyle: TextStyle(color: Colors.blue),
                  hintText: 'Enter some text and/or link to share',
                ),
                maxLines: 1,
                onChanged: (String value) => setState(() {
                  text = value;
                }),
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Share subject:',
                  labelStyle: TextStyle(color: Colors.blue),
                  hintText: 'Enter subject to share (optional)',
                ),
                maxLines: 2,
                onChanged: (String value) => setState(() {
                  subject = value;
                }),
              ),
              const Padding(padding: EdgeInsets.only(top: 12)),
              ListTile(
                leading: Icon(Icons.add),
                title: Text('Add Image'),
                onTap: () async {
                  final pickImage = ImagePicker();
                  final pickFile =
                      await pickImage.pickImage(source: ImageSource.gallery);
                  if (pickFile != null) {
                    setState(() {
                      imagePaths.add(pickFile.path);
                    });
                  }
                },
              ),
              Text(imagePaths == null ? "" : trimmedFileName),
              const Padding(padding: EdgeInsets.only(top: 15.0)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Builder(
                    builder: (BuildContext context) {
                      return ElevatedButton(
                        onPressed: text.isEmpty && imagePaths.isEmpty
                            ? null
                            : () => _onShareData(context),
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.orangeAccent),
                        ),
                        child: const Text('Share'),
                      );
                    },
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 15.0)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Builder(
                    builder: (BuildContext context) {
                      return ElevatedButton(
                        onPressed: text.isEmpty && imagePaths.isEmpty
                            ? null
                            : () => _onShareWithEmptyFields(context),
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.orangeAccent),
                        ),
                        child: const Text('Share with Empty items'),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onShareWithEmptyFields(BuildContext context) async {
    await Share.share("Share is Empty items ");
  }

  _onShareData(BuildContext context) async {
    final RenderBox box = context.findRenderObject() as RenderBox;

    if (imagePaths.isNotEmpty) {
      await Share.shareFiles(imagePaths,
          text: text,
          subject: subject,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    } else {
      await Share.share(text,
          subject: subject,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }
  }
}
