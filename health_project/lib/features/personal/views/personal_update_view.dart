import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_project/commons/constants/enum.dart';
import 'package:health_project/commons/constants/theme.dart';
import 'package:health_project/commons/utils/array_validator.dart';
import 'package:health_project/commons/utils/time_util.dart';
import 'package:health_project/commons/widgets/check_box_widget.dart';
import 'package:health_project/commons/widgets/header_widget.dart';
import 'package:health_project/commons/widgets/message_widget.dart';
import 'package:health_project/commons/widgets/textfield_widget.dart';
import 'package:health_project/features/personal/blocs/personal_bloc.dart';
import 'package:health_project/features/personal/events/personal_event.dart';
import 'package:health_project/features/personal/states/personal_state.dart';
import 'package:health_project/models/account_personal_dto.dart';
import 'package:health_project/services/authentication_helper.dart';
import 'package:health_project/services/gender_select_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersonalUpdateView extends StatelessWidget {
  final AccountPersonalDTO accountPersonalDTO;
  static late final PersonalBloc _personalBloc;
  static final TextEditingController _firstname = TextEditingController();
  static final TextEditingController _lastname = TextEditingController();
  static final _formKey = GlobalKey<FormState>();
  static late DateTime _birthday;
  static late String _genderUpdated;
  static bool _isInitial = true;

  const PersonalUpdateView({required this.accountPersonalDTO});

  void initialServices(BuildContext context) {
    if (_isInitial) {
      _personalBloc = BlocProvider.of(context);
      _isInitial = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    initialServices(context);
    if (_firstname.text.isEmpty || _lastname.text.isEmpty) {
      _firstname.value =
          _firstname.value.copyWith(text: accountPersonalDTO.firstname);
      _lastname.value =
          _lastname.value.copyWith(text: accountPersonalDTO.lastname);
      _birthday = DateTime.parse(accountPersonalDTO.birthday);
      _genderUpdated = accountPersonalDTO.gender;
    }
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SubHeader(title: 'Cá nhân'),
            Expanded(
              child: ListView(
                children: [
                  //msg box
                  BlocConsumer<PersonalBloc, PersonalState>(
                    listener: (context, state) {
                      if (state is PersonalUpdateSuccessState) {
                        //because of stateless widget and having no dispose(). Clear all the textfield before pop.
                        _firstname.clear();
                        _lastname.clear();
                        Navigator.pop(context);
                      }
                    },
                    builder: (context, state) {
                      if (state is PersonalUpdateFailState) {
                        return MessageWidget(
                            message: ArrayValidator.instance
                                .getMsgPersonalUpdate(state.type),
                            type: MessageWidgetType.ERROR);
                      }
                      return Container();
                    },
                  ),
                  Form(
                    key: _formKey,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                      padding: EdgeInsets.only(right: 20, bottom: 10, top: 10),
                      decoration: DefaultTheme.cardDecoration(context),
                      child: Column(
                        children: [
                          //
                          TextFieldHDr(
                            style: TFStyle.NO_BORDER,
                            label: 'Họ',
                            capitalStyle: TextCapitalization.words,
                            labelTextWidth: 60,
                            controller: _lastname,
                            inputType: TFInputType.TF_TEXT,
                            keyboardAction: TextInputAction.next,
                            onChange: (text) {},
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Divider(
                              height: 1,
                              color: DefaultTheme.GREY_LIGHT,
                            ),
                          ),
                          TextFieldHDr(
                            style: TFStyle.NO_BORDER,
                            label: 'Tên',
                            controller: _firstname,
                            capitalStyle: TextCapitalization.words,
                            labelTextWidth: 60,
                            inputType: TFInputType.TF_TEXT,
                            keyboardAction: TextInputAction.done,
                            onChange: (text) {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  //name textfield box

                  //select birthdate box
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                    padding: EdgeInsets.only(
                        left: 20, right: 20, bottom: 10, top: 10),
                    decoration: DefaultTheme.cardDecoration(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Ngày sinh',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 160,
                          height: 200,
                          child: CupertinoTheme(
                            data: CupertinoThemeData(
                              textTheme: CupertinoTextThemeData(
                                dateTimePickerTextStyle: TextStyle(
                                  color: Theme.of(context).hintColor,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            child: CupertinoDatePicker(
                                initialDateTime: _birthday,
                                mode: CupertinoDatePickerMode.date,
                                onDateTimeChanged: (val) {
                                  SystemSound.play(SystemSoundType.click);
                                  _birthday = val;
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //gender box
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                    padding: EdgeInsets.only(
                        left: 20, right: 20, bottom: 20, top: 20),
                    decoration: DefaultTheme.cardDecoration(context),
                    child: Consumer<GenderSelectProvider>(
                      builder: (context, gender, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Giới tính',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                gender.updateGender('man');
                                _genderUpdated = gender.getGender();
                              },
                              child: CheckBoxWidget(
                                check: gender.manCheck,
                                resize: false,
                                edge: 0,
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(right: 10)),
                            Text(
                              'Nam',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(right: 30)),
                            InkWell(
                              onTap: () {
                                gender.updateGender('woman');
                                _genderUpdated = gender.getGender();
                              },
                              child: CheckBoxWidget(
                                check: gender.womenCheck,
                                resize: false,
                                edge: 0,
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(right: 10)),
                            Text(
                              'Nữ',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            //submit button
            _buildButtonWidget(context, 'Cập nhật', onTap: () {
              //update fullname to local device
              String fullname =
                  _lastname.text.trim() + ' ' + _firstname.text.trim();
              if (fullname !=
                  AuthenticateHelper.instance.getFirstNameAndLastName()) {
                AuthenticateHelper.instance
                    .updateFullname(_firstname.text, _lastname.text);
              }
              //update to server
              final AccountPersonalDTO updatedDTO = AccountPersonalDTO(
                  id: AuthenticateHelper.instance.getAccountId(),
                  lastname: _lastname.text.trim(),
                  firstname: _firstname.text.trim(),
                  gender: _genderUpdated,
                  birthday:
                      TimeUtil.instance.formatBirthdayForUpdate(_birthday));
              _personalBloc.add(PersonalEventUpdateInfor(dto: updatedDTO));
            }),
          ]),
    );
  }

  Widget _buildButtonWidget(BuildContext context, String text,
      {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 30, left: 20, right: 20),
        padding: EdgeInsets.only(top: 15, bottom: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: DefaultTheme.BLUE_TEXT,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: DefaultTheme.WHITE,
          ),
        ),
      ),
    );
  }
}
