
import 'package:clean_architecture_app/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key key,
  }) : super(key: key);

  @override
  _TriviaControlsState createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a Number',
          ),
          keyboardType: TextInputType.number,
          controller: controller,
          onSubmitted: (_)=> dispatchConcrete() ,
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
                child: RaisedButton(
              child: Text("Search"),
              color: Theme.of(context).accentColor,
              textTheme: ButtonTextTheme.primary,
              onPressed: dispatchConcrete,
            )),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: RaisedButton(
              child: Text("Get random trivia"),
              onPressed: dispatchRandom,
            )),
          ],
        )
      ],
    );
  }

  void dispatchConcrete() {
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumber(controller.text));
    controller.clear();
  }

  void dispatchRandom() {
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
    controller.clear();
  }
}
