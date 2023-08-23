import 'package:flutter/material.dart';

import '../util/constants.dart';

class BottomNavigationClass extends StatelessWidget {
  const BottomNavigationClass(
      {required this.items, required this.onSelect, super.key});
  final List<BottomNavItem> items;
  final Function(int) onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white,
      height: 60,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // navItem2Widget(items[0]),
          for (var e in items) navItemWidget(e),
        ],
      ),
    );
  }

  navItemWidget(
    BottomNavItem item,
  ) {
    return Expanded(
      child: InkWell(
        onTap: () {
          onSelect(item.index);
        },
        child: Row(
          children: [
            Container(
              width: 20,
              decoration:  BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular((item.index == 1)?10:0),
              topRight: Radius.circular((item.index == 0)?10:0)
            ),),),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                      color: (item.isFirst == true)
                          ? Constants.colorSecondaryVariant
                          : Colors.white,
                      borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  )),
                  child: Container(
                    margin:  EdgeInsets.only(right: 5, left: 5, bottom: (item.isFirst == true)?5:0),
                    decoration: BoxDecoration(
                      color: (item.isFirst == true)
                          ? Constants.buttonColor
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10
                          ),
                    ),
                    width: 50,
                    height: 50,
                    child: (item.isFirst == true)
                        ? const Icon(
                            Icons.add,
                            color: Colors.white,
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: (item.index == 4 && item.isSelected)
                                          ? Constants.buttonColor
                                          : Colors.white),
                                  shape: BoxShape.circle),
                              child: Image(
                                color: item.isSelected
                                    ? (item.index == 4)
                                        ? null
                                        : Constants.buttonColor
                                    : (item.index == 4)
                                        ? null
                                        : Constants.colorOnCard,
                                image: AssetImage(
                                  item.image,
                                ),
                                // width: 25,
                                // fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  navItem2Widget(
    BottomNavItem item,
  ) {
    return InkWell(
      onTap: () {
        onSelect(item.index);
      },
      child: Expanded(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: (item.isFirst == true)
                    ? Constants.buttonColor
                    : Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                border: (item.isFirst == true)
                    ? Border.all(
                        color: Constants.colorSecondaryVariant, width: 5)
                    : null,
              ),
              width: 50,
              height: 50,
              child: (item.isFirst == true)
                  ? const Icon(
                      Icons.add,
                      color: Colors.white,
                    )
                  : Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image(
                        color: item.isSelected
                            ? Constants.buttonColor
                            : Constants.colorOnCard,
                        image: AssetImage(
                          item.image,
                        ),
                        // width: 25,
                        // fit: BoxFit.fitWidth,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class BottomNavItem {
  String image;
  int index;
  bool isSelected;
  bool? isFirst;
  BottomNavItem({
    this.isFirst,
    required this.image,
    required this.index,
    required this.isSelected,
  });
}
