import 'package:flutter/material.dart';
import 'package:health_project/commons/constants/theme.dart';
import 'package:health_project/commons/utils/array_validator.dart';
import 'package:health_project/commons/utils/image_util.dart';
import 'package:health_project/commons/utils/time_util.dart';
import 'package:health_project/commons/widgets/header_widget.dart';
import 'package:health_project/features/personal/blocs/personal_bloc.dart';
import 'package:health_project/features/personal/events/personal_event.dart';
import 'package:health_project/features/personal/states/personal_state.dart';
import 'package:health_project/features/personal/views/contact_update_view.dart';
import 'package:health_project/features/personal/views/password_update_view.dart';
import 'package:health_project/features/personal/views/personal_update_view.dart';
import 'package:health_project/models/account_contact_dto.dart';
import 'package:health_project/models/account_information_dto.dart';
import 'package:health_project/models/account_personal_dto.dart';
import 'package:health_project/services/authentication_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_project/services/gender_select_provider.dart';
import 'package:health_project/services/phone_confirm_provider.dart';
import 'package:provider/provider.dart';

class InformationView extends StatelessWidget {
  static AccountInformationDTO _accountInformationDTO = AccountInformationDTO(
    username: 'n/a',
    phone: 'n/a',
    firstname: 'n/a',
    lastname: 'n/a',
    gender: 'n/a',
    birthday: 'n/a',
    address: 'n/a',
  );
  static late final PersonalBloc _personalBloc;
  static bool _isInitial = true;

  const InformationView();

  Future<void> _getEvent(PersonalBloc bloc) async {
    bloc.add(
      PersonalEventGet(
        id: AuthenticateHelper.instance.getAccountId(),
      ),
    );
  }

  void initialServices(BuildContext context) {
    if (_isInitial) {
      _personalBloc = BlocProvider.of(context);
      _getEvent(_personalBloc);
      _isInitial = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    initialServices(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SubHeader(title: 'Thông tin tài khoản'),
          Expanded(child: BlocBuilder<PersonalBloc, PersonalState>(
            builder: (context, state) {
              if (state is PersonalLoadSuccessState) {
                _accountInformationDTO = state.dto;
              }
              return ListView(
                children: [
                  //avatar widget
                  _buildAvatarWidget(
                    context,
                    '${_accountInformationDTO.lastname} ${_accountInformationDTO.firstname}',
                    _accountInformationDTO.username,
                  ),
                  //buttons widget
                  _buildButtonWidget(
                    context,
                    'Cập nhật ảnh đại diện',
                    onTap: () {},
                  ),
                  _buildButtonWidget(
                    context,
                    'Đổi mật khẩu',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PasswordUpdateView(
                            username: _accountInformationDTO.username,
                          ),
                        ),
                      ).then((_) {
                        _getEvent(_personalBloc);
                      });
                    },
                  ),
                  //build personal section
                  _buildSection(
                    context,
                    'Cá nhân',
                    onTap: () {
                      //get initial gender before move to update
                      Provider.of<GenderSelectProvider>(context, listen: false)
                          .updateGender(_accountInformationDTO.gender);
                      //
                      AccountPersonalDTO _accountPersonalDTO =
                          AccountPersonalDTO(
                        id: AuthenticateHelper.instance.getAccountId(),
                        lastname: _accountInformationDTO.lastname,
                        firstname: _accountInformationDTO.firstname,
                        gender: _accountInformationDTO.gender,
                        birthday: _accountInformationDTO.birthday,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PersonalUpdateView(
                              accountPersonalDTO: _accountPersonalDTO),
                        ),
                      ).then((_) {
                        _getEvent(_personalBloc);
                      });
                    },
                  ),
                  _buildDescriptionBox(
                      context,
                      'Họ tên',
                      '${_accountInformationDTO.lastname} ${_accountInformationDTO.firstname}',
                      false,
                      0,
                      0),
                  Row(
                    children: [
                      Flexible(
                        flex: 3,
                        child: _buildDescriptionBox(
                          context,
                          'Ngày sinh',
                          TimeUtil.instance
                              .formatBirthday(_accountInformationDTO.birthday),
                          true,
                          20,
                          5,
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: _buildDescriptionBox(
                          context,
                          'Giới tính',
                          ArrayValidator.instance
                              .formatGender(_accountInformationDTO.gender),
                          true,
                          5,
                          20,
                        ),
                      ),
                    ],
                  ),
                  _buildSection(
                    context,
                    'Liên hệ',
                    onTap: () {
                      //get initial phone confirm provider
                      Provider.of<PhoneConfirmProvider>(context, listen: false)
                          .updateConfirmedBox(false);
                      Provider.of<PhoneConfirmProvider>(context, listen: false)
                          .updateMatchWithOldPhone(true);
                      //
                      AccountContactDTO _accountContactDTO = AccountContactDTO(
                          id: AuthenticateHelper.instance.getAccountId(),
                          address: _accountInformationDTO.address,
                          phone: _accountInformationDTO.phone);
                      //navigate
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContactUpdateView(
                            accountContactDTO: _accountContactDTO,
                          ),
                        ),
                      ).then((_) {
                        _getEvent(_personalBloc);
                      });
                    },
                  ),
                  _buildDescriptionBox(
                    context,
                    'Số điện thoại',
                    ArrayValidator.instance
                        .formatPhoneNumber(_accountInformationDTO.phone),
                    false,
                    0,
                    0,
                  ),
                  _buildDescriptionBox(
                    context,
                    'Địa chỉ',
                    _accountInformationDTO.address,
                    false,
                    0,
                    0,
                  ),
                ],
              );
            },
          )),
        ],
      ),
    );
  }

  Widget _buildDescriptionBox(
    BuildContext context,
    String title,
    String description,
    bool isSameRow,
    double marginLeft,
    double marginRight,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: (isSameRow)
          ? EdgeInsets.only(left: marginLeft, right: marginRight)
          : EdgeInsets.only(left: 20, right: 20, bottom: 10),
      padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
      decoration: DefaultTheme.cardDecoration(context),
      child: RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).hintColor,
          ),
          children: [
            TextSpan(
              text: '$description\n',
              style: TextStyle(fontSize: 15),
            ),
            TextSpan(
              text: title,
              style: TextStyle(color: DefaultTheme.GREY_TEXT),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String text,
      {required VoidCallback onTap}) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 10),
      child: Row(
        children: [
          Text(
            text.toUpperCase(),
            style: TextStyle(
              color: DefaultTheme.GREY_TEXT,
            ),
          ),
          Spacer(),
          InkWell(
            onTap: onTap,
            child: Text(
              'Sửa',
              style: TextStyle(
                color: DefaultTheme.BLUE_TEXT,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAvatarWidget(
      BuildContext context, String fullname, String username) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
      decoration: DefaultTheme.cardDecoration(context),
      child: Row(
        children: [
          Container(
            width: 65,
            height: 65,
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(65),
              border: Border.all(width: 0.25, color: DefaultTheme.GREY_TEXT),
              image: DecorationImage(
                image: (AuthenticateHelper.instance.getAvatar() != '')
                    ? ImageUtil.instance.getImageNetWork(
                        AuthenticateHelper.instance.getAvatar())
                    : Image.asset('assets/images/avatar-default.jpg').image,
              ),
            ),
          ),
          RichText(
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).hintColor,
              ),
              children: [
                TextSpan(
                  text: '$fullname\n',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: username,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonWidget(BuildContext context, String text,
      {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 10, left: 20, right: 20),
        padding: EdgeInsets.only(top: 15, bottom: 15),
        alignment: Alignment.center,
        decoration: DefaultTheme.cardDecoration(context),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: DefaultTheme.BLUE_TEXT,
          ),
        ),
      ),
    );
  }
}
