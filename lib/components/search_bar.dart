import 'package:flutter/material.dart';

import '../core/theme/base_color.dart';
import 'basic_text.dart';

class search_bar extends StatelessWidget {
  const search_bar({super.key, required this.search});
  final bool search;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (context) => search_screen()));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        width: MediaQuery.of(context).size.width * 1,
        color: AppColors.primarycolor2,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.longestSide * 0.06,
                child: Icon(
                  Icons.search_outlined,
                  size: 30,
                  color: AppColors.grey3,
                ),
              ),
              SizedBox(width: 10),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: search
                    ? TextField(
                        decoration: InputDecoration(
                          hintText: 'Search Brand, Categories',
                          border: InputBorder.none,
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: AppColors.grey3),
                        ),
                      )
                    : basic_text(
                        title: 'Search Brand, Categories',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: AppColors.grey3, fontSize: 18),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
