/************************************************************************/
/* copyright(C) 2013-2016 �����׵���ʶ�Ƽ����޹�˾                      */
/************************************************************************/
#ifndef __EX_IDCARD_RECO_H__
#define __EX_IDCARD_RECO_H__

#ifdef __cplusplus
extern "C" {
#endif

//////////////////////////////////////////////////////////////////////////////
typedef struct tagIDCard 
{
	int nType;//1 �� 2 ���� 0 ʧ��
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
	//���¾��������������stdimage������ϵ
	TRect rtName;
	TRect rtSex;
	TRect rtCardID;
	TRect rtAddress;
	TRect rtNation;
	//TRect rtBirth;
	TRect rtIssue;
	TRect rtValid;
	TRect rtFace;	//����ͼ��
	//////////////////////////////////////////////////////////////////////////
	int idSex;		//�Ա�Ŀ�������
	int idIDNum;	//���֤����������
	int idValid;	//��Ч����������
	//////////////////////////////////////////////////////////////////////////
	int nConfNum, nUnConfNum; //����ʶ����Ŷ�
	float fzoom;	//���ű���
	float fAngle; //���ַ���ת������Ҫ��ʱ����ת���ٽǶ�, 0,90,180,270

	TRect rtCard;	//���ſ���ͼ���е�λ��
	TBitmap *imCard; //У����ı�׼ͼ��
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

