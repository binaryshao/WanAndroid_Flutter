import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/util/apis.dart';
import 'package:wanandroid_flutter/util/hint_uitl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:wanandroid_flutter/util/nav_util.dart';
import 'package:wanandroid_flutter/config/event.dart';

class EditTodoPage extends StatefulWidget {
  final item;

  const EditTodoPage({Key key, this.item}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EditTodoPageState();
  }
}

class _EditTodoPageState extends State<EditTodoPage> {
  final formKey = GlobalKey<FormState>();
  var _title, _content, _dateStr, _status;
  bool _isLoading = false;
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    _status = widget.item == null ? 0 : widget.item['status'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? '新建任务' : '编辑任务'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Form(
                key: formKey,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TextFormField(
                        initialValue:
                            widget.item != null ? widget.item['title'] : '',
                        validator: (value) =>
                            value.isEmpty ? '标题不能为空...' : null,
                        onSaved: (value) => _title = value,
                        decoration: InputDecoration(
                          hintText: '请输入标题',
                          labelText: '标题',
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: TextFormField(
                          initialValue:
                              widget.item != null ? widget.item['content'] : '',
                          validator: (value) =>
                              value.isEmpty ? '内容不能为空...' : null,
                          onSaved: (value) => _content = value,
                          decoration: InputDecoration(
                            hintText: '请输入内容',
                            labelText: '内容',
                          ),
                        ),
                      ),
                      DateTimeField(
                        format: dateFormat,
                        initialValue: widget.item == null
                            ? DateTime.now()
                            : DateTime.parse(widget.item['dateStr']),
                        decoration: InputDecoration(
                          hintText: '请选择完成时间',
                          labelText: '完成时间',
                        ),
                        onSaved: (value) => _dateStr = dateFormat.format(value),
                        readOnly: true,
                        resetIcon: null,
                        onShowPicker: (context, currentValue) {
                          return showDatePicker(
                              context: context,
                              firstDate: DateTime(2000),
                              initialDate: currentValue ?? DateTime.now(),
                              lastDate: DateTime(2500));
                        },
                      ),
                      getSwitch(),
                      Container(
                        margin: EdgeInsets.all(30),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            width: 200,
                            height: 45,
                            child: RaisedButton(
                              child: Text(_isLoading ? '提交中...' : '提交'),
                              onPressed: _isLoading ? null : _submit,
                              textColor: Colors.white,
                              disabledTextColor: Colors.white,
                              color: Theme.of(context).primaryColor,
                              disabledColor: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }

  getSwitch() {
    if (widget.item == null) {
      return Container();
    } else {
      return Container(
        margin: EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '是否已完成',
              style: TextStyle(fontSize: 13),
            ),
            Switch(
              onChanged: (bool value) {
                setState(() {
                  _status = value ? 1 : 0;
                });
              },
              value: _status == 1,
            ),
          ],
        ),
      );
    }
  }

  _submit() {
    final formState = formKey.currentState;
    if (formState.validate()) {
      formState.save();
      setState(() {
        _isLoading = true;
      });
      Future future = widget.item == null
          ? Apis.todoAdd(_title, _content, _dateStr)
          : Apis.todoUpdate(
              widget.item['id'], _title, _content, _dateStr, _status.toString());
      future.then((result) {
        HintUtil.toast(context, widget.item == null ? '新增成功' : '编辑成功');
        eventBus.fire(Todo());
        NavUtil.pop(context);
      }).catchError((e) {
        HintUtil.toast(context, e.toString());
      }).whenComplete(() {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }
}
