import 'package:flutter/material.dart';
import 'package:smartx_flutter_app/helper/material_dailog_content.dart';
import 'package:smartx_flutter_app/util/constants.dart';


class MaterialDialogHelper {
  static MaterialDialogHelper? _instance;

  MaterialDialogHelper._();

  static MaterialDialogHelper instance() {
    _instance ??= MaterialDialogHelper._();
    return _instance!;
  }

  BuildContext? _context;

  void injectContext(BuildContext context) => _context = context;

  void hideDialog() {
    final context = _context;
    if (context == null) return;
    Navigator.pop(context);
  }

  void dismissProgress() {
    final context = _context;
    if (context == null) return;
    Navigator.pop(context);
  }

  void showProgressDialog(String text) {
    final context = _context;
    if (context == null) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
              child: Dialog(
                  backgroundColor: Constants.colorSecondaryVariant,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  child: Padding(
                      padding: const EdgeInsets.only(
                          top: 15, bottom: 15, left: 25, right: 25),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const CircularProgressIndicator(strokeWidth: 3,color: Constants.colorSecondary,),
                        const SizedBox(width: 10),
                        Flexible(
                            child: Text(text,
                                style: const TextStyle(
                                    color: Constants.colorSecondary,
                                    fontSize: 14)))
                      ]))),
              onWillPop: () async => false);
        });
  }

  void showMaterialDialogWithContent(
      MaterialDialogContent content, Function positiveClickListener,
      {Function? negativeClickListener}) {
    final context = _context;
    if (context == null) return;
    showDialog(
        context: context,
        builder: (_) {
          return WillPopScope(
              child: AlertDialog(
                  insetPadding: const EdgeInsets.symmetric(horizontal: 25),
                  contentPadding: const EdgeInsets.all(0),
                  backgroundColor: Constants.colorSecondaryVariant,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(content.title,
                                style: const TextStyle(
                                    fontFamily: Constants.workSansMedium,
                                    fontSize: 20,
                                    color: Constants.colorOnSecondary))),
                        const SizedBox(height: 10),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(content.message,
                                style: TextStyle(
                                    color: Constants.colorOnSecondary
                                        .withOpacity(0.5),
                                    fontSize: 14,
                                    fontFamily: Constants.workSansMedium))),
                        const SizedBox(height: 30),
                        Divider(
                            thickness: 0.8,
                            color: Colors.black.withOpacity(0.1),
                            height: 0),
                        IntrinsicHeight(
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Expanded(
                                  flex: 1,
                                  child: InkWell(
                                      borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(16)),
                                      onTap: content.negativeText.isNotEmpty
                                          ? () {
                                              Navigator.pop(context);
                                              negativeClickListener?.call();
                                            }
                                          : null,
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 13),
                                          child: Text(
                                              content.negativeText
                                                  .toUpperCase(),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Constants
                                                      .colorOnSecondary,
                                                  fontSize: 14,
                                                  fontFamily: Constants
                                                      .workSansMedium))))),
                              VerticalDivider(
                                  thickness: 0.8,
                                  color:
                                      Constants.colorOnSurface.withOpacity(0.1),
                                  width: 0),
                              Expanded(
                                  flex: 1,
                                  child: InkWell(
                                      borderRadius: const BorderRadius.only(
                                          bottomRight: Radius.circular(16)),
                                      onTap: () {
                                        Navigator.pop(context);
                                        positiveClickListener.call();
                                      },
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 13),
                                          child: Text(
                                              content.positiveText
                                                  .toUpperCase(),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Constants.colorPrimaryVariant,
                                                  fontSize: 14,
                                                  fontFamily: Constants
                                                      .workSansMedium)))))
                            ]))
                      ])),
              onWillPop: () async => false);
        });
  }


}
