package com.dh.health.util;

public class NotificationTypeUtil {
	private static final String CALENDAR = "CALENDAR";
	private static final String VITAL_SIGN = "VITAL_SIGN";
	private static final String CONTRACT = "CONTRACT";
	//
	
	private static final int KEY_CALENDAR = 7;
	private static final int KEY_VT_MEASURE = 1;
	private static final int KET_VT_DANGER = 2;
	private static final int KEY_CT_REQ = 3;
	private static final int KEY_CT_CONFIRMED = 4;
	private static final int KEY_CT_OUT_DATE = 5;
	private static final int KEY_CT_DENY = 6;
	
	//
	private static final String STATUS_UNREAD = "UNREAD";
	//private static final String STATUS_NOTI_FAILED = "NOTI_FAILED";
	private static final String STATUS_READ = "READ";
	
	//
	private static final String MSG_CREATE_EVENT = "Bác sĩ đã tạo lịch hẹn mới với bạn:";
	
	
	public String getCalendar() {
		return CALENDAR;
	}
	public String getVitalSign() {
		return VITAL_SIGN;
	}
	public String getContract() {
		return CONTRACT;
	}
	public String getStatusUnread() {
		return STATUS_UNREAD;
	}
	public String getStatusRead() {
		return STATUS_READ;
	}
//	public String getStatusNotiFailed() {
//		return STATUS_NOTI_FAILED;
//	}
	public int getKeyCalendar() {
		return KEY_CALENDAR;
	}
	public int getKeyVtMeasure() {
		return KEY_VT_MEASURE;
	}
	public int getKetVtDanger() {
		return KET_VT_DANGER;
	}
	public int getKeyCtReq() {
		return KEY_CT_REQ;
	}
	public int getKeyCtConfirmed() {
		return KEY_CT_CONFIRMED;
	}
	public int getKeyCtOutDate() {
		return KEY_CT_OUT_DATE;
	}
	public int getKeyCtDeny() {
		return KEY_CT_DENY;
	}
	public String getMsgCreateEvent() {
		return MSG_CREATE_EVENT;
	}
	
	
	
}
