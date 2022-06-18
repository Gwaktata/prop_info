import 'package:xml/xml.dart';

import '../util/xml_utils.dart';

class WfsVo {
  String id;
  double posX;  // 위도
  double posY;  // 경도
  double xCrdnt;
  double yCrdnt;
  String pnu;  // 고유번호
  String ldCpsgCode;
  String ldEmdLiCode;
  String regstrSeCode;
  String mnnm;  // 본번
  String slno;
  String stdrYear;
  String stdrMt;
  String aphusCode;
  String aphusSeCode;  // 공동주택구분코드
  String aphusNm;  // 공동주택명
  String dongNm;
  int avrgPblntfPc;  // 평균공시가격(원)
  int allPblntfPc;  // 전체공시가격(원)
  int unitArPc;  // 단위면적가격(원/㎡)
  int calcAphusHoCo;
  int pstyr1AvrgPblntfPc;
  int pstyr2AvrgPblntfPc;
  int pstyr3AvrgPblntfPc;
  int pstyr4AvrgPblntfPc;
  String frstRegistDt;  // 기준일

  WfsVo({
    required this.id,
    required this.posX,
    required this.posY,
    required this.xCrdnt,
    required this.yCrdnt,
    required this.pnu,
    required this.ldCpsgCode,
    required this.ldEmdLiCode,
    required this.regstrSeCode,
    required this.mnnm,
    required this.slno,
    required this.stdrYear,
    required this.stdrMt,
    required this.aphusCode,
    required this.aphusSeCode,
    required this.aphusNm,
    required this.dongNm,
    required this.avrgPblntfPc,
    required this.allPblntfPc,
    required this.unitArPc,
    required this.calcAphusHoCo,
    required this.pstyr1AvrgPblntfPc,
    required this.pstyr2AvrgPblntfPc,
    required this.pstyr3AvrgPblntfPc,
    required this.pstyr4AvrgPblntfPc,
    required this.frstRegistDt,
  });

  factory WfsVo.fromXml(XmlElement xml) {
    return WfsVo(
      id: xml.attributes[0].toString(),
      posX: double.parse(XmlUtils.searchResult(xml, 'gml:pos').split(' ')[0]) +
          0.00308031117795,
      posY: double.parse(XmlUtils.searchResult(xml, 'gml:pos').split(' ')[1]) -
          0.0022027815388,
      xCrdnt: double.parse(XmlUtils.searchResult(xml, 'NSDI:X_CRDNT')),
      yCrdnt: double.parse(XmlUtils.searchResult(xml, 'NSDI:Y_CRDNT')),
      pnu: XmlUtils.searchResult(xml, 'NSDI:PNU'),
      ldCpsgCode: XmlUtils.searchResult(xml, 'NSDI:LD_CPSG_CODE'),
      ldEmdLiCode: XmlUtils.searchResult(xml, 'NSDI:LD_EMD_LI_CODE'),
      regstrSeCode: XmlUtils.searchResult(xml, 'NSDI:REGSTR_SE_CODE'),
      mnnm: XmlUtils.searchResult(xml, 'NSDI:MNNM'),
      slno: XmlUtils.searchResult(xml, 'NSDI:SLNO'),
      stdrYear: XmlUtils.searchResult(xml, 'NSDI:STDR_YEAR'),
      stdrMt: XmlUtils.searchResult(xml, 'NSDI:STDR_MT'),
      aphusCode: XmlUtils.searchResult(xml, 'NSDI:APHUS_CODE'),
      aphusSeCode: XmlUtils.searchResult(xml, 'NSDI:APHUS_SE_CODE'),
      aphusNm: XmlUtils.searchResult(xml, 'NSDI:APHUS_NM'),
      dongNm: XmlUtils.searchResult(xml, 'NSDI:DONG_NM'),
      avrgPblntfPc:
          int.parse(XmlUtils.searchResult(xml, 'NSDI:AVRG_PBLNTF_PC')),
      allPblntfPc: int.parse(XmlUtils.searchResult(xml, 'NSDI:ALL_PBLNTF_PC')),
      unitArPc: int.parse(XmlUtils.searchResult(xml, 'NSDI:UNIT_AR_PC')),
      calcAphusHoCo:
          int.parse(XmlUtils.searchResult(xml, 'NSDI:CALC_APHUS_HO_CO')),
      pstyr1AvrgPblntfPc:
          int.parse(XmlUtils.searchResult(xml, 'NSDI:PSTYR_1_AVRG_PBLNTF_PC')),
      pstyr2AvrgPblntfPc:
          int.parse(XmlUtils.searchResult(xml, 'NSDI:PSTYR_2_AVRG_PBLNTF_PC')),
      pstyr3AvrgPblntfPc:
          int.parse(XmlUtils.searchResult(xml, 'NSDI:PSTYR_3_AVRG_PBLNTF_PC')),
      pstyr4AvrgPblntfPc:
          int.parse(XmlUtils.searchResult(xml, 'NSDI:PSTYR_4_AVRG_PBLNTF_PC')),
      frstRegistDt:
          XmlUtils.searchResult(xml, 'NSDI:FRST_REGIST_DT').split('T')[0],
    );
  }
}
