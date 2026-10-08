package egovframework.wnn_medcost.mis.service.impl;

import javax.annotation.Resource;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import egovframework.wnn_medcost.mis.service.MisService;

/**
 * MIS 업무 알림 자동 발송 (2026-10-08) — 평일 08:30 에 한 번.
 *
 * · 켜는 조건 = mail.properties 의 noti.auto.enabled=true (★운영에서만 켠다 — 개발 PC 톰캣이 운영 DB 를 보므로 기본은 꺼짐).
 * · 하루 한 번 보장 = MisServiceImpl.runAutoNoti 가 TBL_MIS_NOTI_RUN 에 오늘 날짜를 INSERT IGNORE 로 선점한 쪽만 보낸다
 *   (운영 톰캣에 같은 앱이 두 벌(ROOT·wnn_medcost-1.0.0) 올라가 있어 둘 다 돌아도 한 번만 나간다).
 * · 스케줄은 context-common.xml 의 task:annotation-driven 이 켠다(루트 컨텍스트 — @Service 는 거기 산다).
 */
@Service("MisNotiScheduler")
public class MisNotiScheduler {

	@Resource(name = "MisService")
	private MisService svc;

	/** 초 분 시 일 월 요일 — 평일 08:30 */
	@Scheduled(cron = "0 30 8 * * MON-FRI")
	public void run() {
		try {
			java.util.Properties p = egovframework.util.MailUtil.config();
			if (!"true".equalsIgnoreCase(String.valueOf(p.getProperty("noti.auto.enabled", "false")).trim())) return;
			java.util.Map<String, Object> r = svc.runAutoNoti();
			System.out.println("[MIS 알림 자동발송] " + r);
		} catch (Exception e) {
			System.out.println("[MIS 알림 자동발송] 실패: " + e.getMessage());
		}
	}
}
