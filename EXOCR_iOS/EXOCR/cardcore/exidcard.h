/************************************************************************/
/* copyright(C) 2013-2016 北京易道博识科技有限公司                      */
/************************************************************************/
#ifndef __EX_IDCARD_RECO_H__
#define __EX_IDCARD_RECO_H__

#ifdef __cplusplus
extern "C" {
#endif

//////////////////////////////////////////////////////////////////////////////
typedef struct tagIDCard 
{
	int nType;//1 正 2 反面 0 失败
	//////////////////////////////////////////////////////////////////////////
	char szName[64];
	char szSex[4];
	char szCardID[32];
	char szAddress[256];
	char szNation[16];	
	char szBirth[16];
	char szIssue[64];	
	char szValid[64];
	//////////////////////////////////////////////////////////////////////////
	//以下矩形是相对于整个stdimage的坐标系
	TRect rtName;
	TRect rtSex;
	TRect rtCardID;
	TRect rtAddress;
	TRect rtNation;
	//TRect rtBirth;
	TRect rtIssue;
	TRect rtValid;
	TRect rtFace;	//人脸图像
	//////////////////////////////////////////////////////////////////////////
	int idSex;		//性别的块索引号
	int idIDNum;	//身份证号码索引号
	int idValid;	//有效日期索引号
	//////////////////////////////////////////////////////////////////////////
	int nConfNum, nUnConfNum; //整张识别可信度
	float fzoom;	//缩放比例
	float fAngle; //文字方向转正，需要逆时针旋转多少角度, 0,90,180,270

	TRect rtCard;	//整张卡在图像中的位置
	TBitmap *imCard; //校正后的标准图像
	//////////////////////////////////////////////////////////////////////////
}EXIDCard;

//////////////////////////////////////////////////////////////////////////
//
int EXIDCardResToStr(char *szResBuf, const int iBufSize, EXIDCard *pstIDCard);
int EXIDCardAjustRect(EXIDCard *pstIDCard, int lft, int top);
int EXIDCardReco1(TBitmap *pstImage, int nRecoMode, EXIDCard *pstIDCard);
int EXIDCardReco2(TBitmap *pstImage, int nRecoMode, char *szResBuf, int nResBufSize);

#ifdef __cplusplus
}
#endif

#endif //__EX_IDCARD_RECO_H__

