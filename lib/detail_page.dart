import 'package:flutter/material.dart';
import 'package:prop_info/util/utils.dart';

import 'vo/wfs_vo.dart';

class DetailPage extends StatelessWidget {
  final WfsVo wfs;
  final String address;

  DetailPage({required this.wfs, required this.address});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('남소유'),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            FittedBox(
              child: Text(
                wfs.aphusNm,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              fit: BoxFit.contain,
            ),
            SizedBox(height: 60),
            Container(
              height: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text('주소'),
                      FittedBox(
                        child: Text(
                          '${address}',
                        ),
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text('전체공시가격(원)'),
                      FittedBox(
                        child: Text(
                          '${Utils().getFormattedNum(wfs.allPblntfPc.toString())} 원',
                        ),
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text('평균공시가격(원)'),
                      FittedBox(
                        child: Text(
                          '${Utils().getFormattedNum(wfs.avrgPblntfPc.toString())} 원',
                        ),
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text('단위면적가격(원/m2)'),
                      FittedBox(
                        child: Text(
                          '${Utils().getFormattedNum(wfs.unitArPc.toString())} 원',
                        ),
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text('데이터기준일자'),
                      FittedBox(
                        child: Text(
                          wfs.frstRegistDt,
                        ),
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
