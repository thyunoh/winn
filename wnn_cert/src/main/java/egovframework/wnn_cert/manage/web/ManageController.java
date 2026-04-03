package egovframework.wnn_cert.manage.web;

import egovframework.wnn_cert.manage.model.*;
import egovframework.wnn_cert.manage.service.ManageService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/manage")
public class ManageController {

    @Resource(name = "ManageService")
    private ManageService manageService;

    // ========== 페이지 이동 ==========

    @RequestMapping("/vaccinMain.do")
    public String vaccinMain() {
        return ".main/manage/vaccinMain";
    }

    @RequestMapping("/restraintMain.do")
    public String restraintMain() {
        return ".main/manage/restraintMain";
    }

    @RequestMapping("/fireEquipMain.do")
    public String fireEquipMain() {
        return ".main/manage/fireEquipMain";
    }

    @RequestMapping("/staffEduMain.do")
    public String staffEduMain() {
        return ".main/manage/staffEduMain";
    }

    @RequestMapping("/healthChkMain.do")
    public String healthChkMain() {
        return ".main/manage/healthChkMain";
    }

    @RequestMapping("/medDeviceMain.do")
    public String medDeviceMain() {
        return ".main/manage/medDeviceMain";
    }

    @RequestMapping("/staffDutyMain.do")
    public String staffDutyMain() {
        return ".main/manage/staffDutyMain";
    }

    @RequestMapping("/mealRoundMain.do")
    public String mealRoundMain() {
        return ".main/manage/mealRoundMain";
    }

    @RequestMapping("/drugManageMain.do")
    public String drugManageMain() {
        return ".main/manage/drugManageMain";
    }

    @RequestMapping("/infectionMain.do")
    public String infectionMain() {
        return ".main/manage/infectionMain";
    }

    @RequestMapping("/handHygieneMain.do")
    public String handHygieneMain() {
        return ".main/manage/handHygieneMain";
    }

    // ========== 인증 실사 핵심 페이지 ==========
    @RequestMapping("/mockSurveyMain.do")
    public String mockSurveyMain() { return ".main/manage/mockSurveyMain"; }
    @RequestMapping("/selfCheckMain.do")
    public String selfCheckMain() { return ".main/manage/selfCheckMain"; }
    @RequestMapping("/certDocStatusMain.do")
    public String certDocStatusMain() { return ".main/manage/certDocStatusMain"; }
    @RequestMapping("/tempLogMain.do")
    public String tempLogMain() { return ".main/manage/tempLogMain"; }
    @RequestMapping("/satisfactionMain.do")
    public String satisfactionMain() { return ".main/manage/satisfactionMain"; }
    @RequestMapping("/emergencyMain.do")
    public String emergencyMain() { return ".main/manage/emergencyMain"; }

    // ========== 추가 페이지 이동 ==========
    @RequestMapping("/certScheduleMain.do")
    public String certScheduleMain() { return ".main/manage/certScheduleMain"; }
    @RequestMapping("/guidebookMain.do")
    public String guidebookMain() { return ".main/manage/guidebookMain"; }
    @RequestMapping("/formCompleteMain.do")
    public String formCompleteMain() { return ".main/manage/formCompleteMain"; }
    @RequestMapping("/workPlanMain.do")
    public String workPlanMain() { return ".main/manage/workPlanMain"; }
    @RequestMapping("/qpsMain.do")
    public String qpsMain() { return ".main/manage/qpsMain"; }
    @RequestMapping("/patientCntMain.do")
    public String patientCntMain() { return ".main/manage/patientCntMain"; }
    @RequestMapping("/returnHomeMain.do")
    public String returnHomeMain() { return ".main/manage/returnHomeMain"; }
    @RequestMapping("/tatMain.do")
    public String tatMain() { return ".main/manage/tatMain"; }
    @RequestMapping("/pathologyTatMain.do")
    public String pathologyTatMain() { return ".main/manage/pathologyTatMain"; }
    @RequestMapping("/rptMain.do")
    public String rptMain() { return ".main/manage/rptMain"; }
    @RequestMapping("/fallMain.do")
    public String fallMain() { return ".main/manage/fallMain"; }
    @RequestMapping("/pressureUlcerMain.do")
    public String pressureUlcerMain() { return ".main/manage/pressureUlcerMain"; }
    @RequestMapping("/painAssessMain.do")
    public String painAssessMain() { return ".main/manage/painAssessMain"; }
    @RequestMapping("/restraintRecordMain.do")
    public String restraintRecordMain() { return ".main/manage/restraintRecordMain"; }
    @RequestMapping("/restraintLogMain.do")
    public String restraintLogMain() { return ".main/manage/restraintLogMain"; }
    @RequestMapping("/consentMain.do")
    public String consentMain() { return ".main/manage/consentMain"; }
    @RequestMapping("/sterilizeMain.do")
    public String sterilizeMain() { return ".main/manage/sterilizeMain"; }
    @RequestMapping("/infInspectMain.do")
    public String infInspectMain() { return ".main/manage/infInspectMain"; }
    @RequestMapping("/laundryMain.do")
    public String laundryMain() { return ".main/manage/laundryMain"; }
    @RequestMapping("/wasteMain.do")
    public String wasteMain() { return ".main/manage/wasteMain"; }
    @RequestMapping("/patientChartMain.do")
    public String patientChartMain() { return ".main/manage/patientChartMain"; }
    @RequestMapping("/pharmPatientMain.do")
    public String pharmPatientMain() { return ".main/manage/pharmPatientMain"; }
    @RequestMapping("/nutritionMain.do")
    public String nutritionMain() { return ".main/manage/nutritionMain"; }
    @RequestMapping("/rehabMain.do")
    public String rehabMain() { return ".main/manage/rehabMain"; }
    @RequestMapping("/dischargeMain.do")
    public String dischargeMain() { return ".main/manage/dischargeMain"; }
    @RequestMapping("/staffMain.do")
    public String staffMain() { return ".main/manage/staffMain"; }
    @RequestMapping("/dutyScheduleMain.do")
    public String dutyScheduleMain() { return ".main/manage/dutyScheduleMain"; }
    @RequestMapping("/vacationMain.do")
    public String vacationMain() { return ".main/manage/vacationMain"; }
    @RequestMapping("/cprDrillMain.do")
    public String cprDrillMain() { return ".main/manage/cprDrillMain"; }
    @RequestMapping("/staffReportMain.do")
    public String staffReportMain() { return ".main/manage/staffReportMain"; }
    @RequestMapping("/safetyRoundMain.do")
    public String safetyRoundMain() { return ".main/manage/safetyRoundMain"; }
    @RequestMapping("/waterQualityMain.do")
    public String waterQualityMain() { return ".main/manage/waterQualityMain"; }
    @RequestMapping("/wardDeviceMain.do")
    public String wardDeviceMain() { return ".main/manage/wardDeviceMain"; }
    @RequestMapping("/companyMain.do")
    public String companyMain() { return ".main/manage/companyMain"; }
    @RequestMapping("/deptMain.do")
    public String deptMain() { return ".main/manage/deptMain"; }
    @RequestMapping("/wardMain.do")
    public String wardMain() { return ".main/manage/wardMain"; }
    @RequestMapping("/positionMain.do")
    public String positionMain() { return ".main/manage/positionMain"; }
    @RequestMapping("/teamMain.do")
    public String teamMain() { return ".main/manage/teamMain"; }
    @RequestMapping("/committeeMain.do")
    public String committeeMain() { return ".main/manage/committeeMain"; }
    @RequestMapping("/complaintMain.do")
    public String complaintMain() { return ".main/manage/complaintMain"; }
    @RequestMapping("/templateMain.do")
    public String templateMain() { return ".main/manage/templateMain"; }
    @RequestMapping("/fileMain.do")
    public String fileMain() { return ".main/manage/fileMain"; }
    @RequestMapping("/boardMain.do")
    public String boardMain() { return ".main/manage/boardMain"; }
    @RequestMapping("/noticeMain.do")
    public String noticeMain() { return ".main/manage/noticeMain"; }
    @RequestMapping("/userMain.do")
    public String userMain() { return ".main/manage/userMain"; }
    @RequestMapping("/menuAuthMain.do")
    public String menuAuthMain() { return ".main/manage/menuAuthMain"; }
    @RequestMapping("/signLineMain.do")
    public String signLineMain() { return ".main/manage/signLineMain"; }
    @RequestMapping("/loginHistMain.do")
    public String loginHistMain() { return ".main/manage/loginHistMain"; }
    @RequestMapping("/smsMain.do")
    public String smsMain() { return ".main/manage/smsMain"; }

    // ========== 예방접종 ==========

    @RequestMapping(value = "/getVaccinList.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getVaccinList(VaccinDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            List<VaccinDTO> list = manageService.getVaccinList(dto);
            resultMap.put("result", "success");
            resultMap.put("data", list);
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/saveVaccin.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> saveVaccin(VaccinDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            if (dto.getHospCd() == null || dto.getHospCd().isEmpty()) {
                dto.setHospCd("12345678");
            }
            boolean result;
            if ("U".equals(dto.getMode())) {
                result = manageService.updateVaccin(dto);
            } else {
                result = manageService.insertVaccin(dto);
            }
            resultMap.put("result", result ? "success" : "fail");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/deleteVaccin.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> deleteVaccin(VaccinDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            boolean result = manageService.deleteVaccin(dto);
            resultMap.put("result", result ? "success" : "fail");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    // ========== 격리/강박 ==========

    @RequestMapping(value = "/getRestraintList.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getRestraintList(RestraintDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            List<RestraintDTO> list = manageService.getRestraintList(dto);
            resultMap.put("result", "success");
            resultMap.put("data", list);
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/saveRestraint.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> saveRestraint(RestraintDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            if (dto.getHospCd() == null || dto.getHospCd().isEmpty()) {
                dto.setHospCd("12345678");
            }
            boolean result;
            if ("U".equals(dto.getMode())) {
                result = manageService.updateRestraint(dto);
            } else {
                result = manageService.insertRestraint(dto);
            }
            resultMap.put("result", result ? "success" : "fail");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/deleteRestraint.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> deleteRestraint(RestraintDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            boolean result = manageService.deleteRestraint(dto);
            resultMap.put("result", result ? "success" : "fail");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    // ========== 소방설비 ==========

    @RequestMapping(value = "/getFireEquipList.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getFireEquipList(FireEquipDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            List<FireEquipDTO> list = manageService.getFireEquipList(dto);
            resultMap.put("result", "success");
            resultMap.put("data", list);
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/saveFireEquip.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> saveFireEquip(FireEquipDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            if (dto.getHospCd() == null || dto.getHospCd().isEmpty()) {
                dto.setHospCd("12345678");
            }
            boolean result;
            if ("U".equals(dto.getMode())) {
                result = manageService.updateFireEquip(dto);
            } else {
                result = manageService.insertFireEquip(dto);
            }
            resultMap.put("result", result ? "success" : "fail");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/deleteFireEquip.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> deleteFireEquip(FireEquipDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            boolean result = manageService.deleteFireEquip(dto);
            resultMap.put("result", result ? "success" : "fail");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    // ========== 직원교육 ==========

    @RequestMapping(value = "/getStaffEduList.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getStaffEduList(StaffEduDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            List<StaffEduDTO> list = manageService.getStaffEduList(dto);
            resultMap.put("result", "success");
            resultMap.put("data", list);
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/saveStaffEdu.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> saveStaffEdu(StaffEduDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            if (dto.getHospCd() == null || dto.getHospCd().isEmpty()) {
                dto.setHospCd("12345678");
            }
            boolean result;
            if ("U".equals(dto.getMode())) {
                result = manageService.updateStaffEdu(dto);
            } else {
                result = manageService.insertStaffEdu(dto);
            }
            resultMap.put("result", result ? "success" : "fail");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/deleteStaffEdu.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> deleteStaffEdu(StaffEduDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            boolean result = manageService.deleteStaffEdu(dto);
            resultMap.put("result", result ? "success" : "fail");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    // ========== 교육참석자 ==========

    @RequestMapping(value = "/getStaffEduAttList.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getStaffEduAttList(StaffEduAttDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            List<StaffEduAttDTO> list = manageService.getStaffEduAttList(dto);
            resultMap.put("result", "success");
            resultMap.put("data", list);
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/saveStaffEduAtt.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> saveStaffEduAtt(StaffEduAttDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            boolean result;
            if ("U".equals(dto.getMode())) {
                result = manageService.updateStaffEduAtt(dto);
            } else {
                result = manageService.insertStaffEduAtt(dto);
            }
            resultMap.put("result", result ? "success" : "fail");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/deleteStaffEduAtt.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> deleteStaffEduAtt(StaffEduAttDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            boolean result = manageService.deleteStaffEduAtt(dto);
            resultMap.put("result", result ? "success" : "fail");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    // ========== 건강검진 ==========

    @RequestMapping(value = "/getHealthChkList.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getHealthChkList(HealthChkDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            List<HealthChkDTO> list = manageService.getHealthChkList(dto);
            resultMap.put("result", "success");
            resultMap.put("data", list);
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/saveHealthChk.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> saveHealthChk(HealthChkDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            if (dto.getHospCd() == null || dto.getHospCd().isEmpty()) {
                dto.setHospCd("12345678");
            }
            boolean result;
            if ("U".equals(dto.getMode())) {
                result = manageService.updateHealthChk(dto);
            } else {
                result = manageService.insertHealthChk(dto);
            }
            resultMap.put("result", result ? "success" : "fail");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/deleteHealthChk.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> deleteHealthChk(HealthChkDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            boolean result = manageService.deleteHealthChk(dto);
            resultMap.put("result", result ? "success" : "fail");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    // ========== 의료기기 ==========

    @RequestMapping(value = "/getMedDeviceList.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getMedDeviceList(MedDeviceDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            List<MedDeviceDTO> list = manageService.getMedDeviceList(dto);
            resultMap.put("result", "success");
            resultMap.put("data", list);
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/saveMedDevice.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> saveMedDevice(MedDeviceDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            if (dto.getHospCd() == null || dto.getHospCd().isEmpty()) {
                dto.setHospCd("12345678");
            }
            boolean result;
            if ("U".equals(dto.getMode())) {
                result = manageService.updateMedDevice(dto);
            } else {
                result = manageService.insertMedDevice(dto);
            }
            resultMap.put("result", result ? "success" : "fail");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/deleteMedDevice.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> deleteMedDevice(MedDeviceDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            boolean result = manageService.deleteMedDevice(dto);
            resultMap.put("result", result ? "success" : "fail");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    // ========== 당직/인력 ==========

    @RequestMapping(value = "/getStaffDutyList.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getStaffDutyList(StaffDutyDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            List<StaffDutyDTO> list = manageService.getStaffDutyList(dto);
            resultMap.put("result", "success");
            resultMap.put("data", list);
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/saveStaffDuty.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> saveStaffDuty(StaffDutyDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            if (dto.getHospCd() == null || dto.getHospCd().isEmpty()) {
                dto.setHospCd("12345678");
            }
            boolean result;
            if ("U".equals(dto.getMode())) {
                result = manageService.updateStaffDuty(dto);
            } else {
                result = manageService.insertStaffDuty(dto);
            }
            resultMap.put("result", result ? "success" : "fail");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/deleteStaffDuty.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> deleteStaffDuty(StaffDutyDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            boolean result = manageService.deleteStaffDuty(dto);
            resultMap.put("result", result ? "success" : "fail");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    // ========== 배식라운딩 ==========

    @RequestMapping(value = "/getMealRoundList.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getMealRoundList(MealRoundDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            List<MealRoundDTO> list = manageService.getMealRoundList(dto);
            resultMap.put("result", "success");
            resultMap.put("data", list);
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/saveMealRound.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> saveMealRound(MealRoundDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            if (dto.getHospCd() == null || dto.getHospCd().isEmpty()) {
                dto.setHospCd("12345678");
            }
            boolean result;
            if ("U".equals(dto.getMode())) {
                result = manageService.updateMealRound(dto);
            } else {
                result = manageService.insertMealRound(dto);
            }
            resultMap.put("result", result ? "success" : "fail");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/deleteMealRound.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> deleteMealRound(MealRoundDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            boolean result = manageService.deleteMealRound(dto);
            resultMap.put("result", result ? "success" : "fail");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    // ========== 약품관리 ==========

    @RequestMapping(value = "/getDrugManageList.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getDrugManageList(DrugManageDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            List<DrugManageDTO> list = manageService.getDrugManageList(dto);
            resultMap.put("result", "success");
            resultMap.put("data", list);
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/saveDrugManage.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> saveDrugManage(DrugManageDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            if (dto.getHospCd() == null || dto.getHospCd().isEmpty()) {
                dto.setHospCd("12345678");
            }
            boolean result;
            if ("U".equals(dto.getMode())) {
                result = manageService.updateDrugManage(dto);
            } else {
                result = manageService.insertDrugManage(dto);
            }
            resultMap.put("result", result ? "success" : "fail");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/deleteDrugManage.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> deleteDrugManage(DrugManageDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            boolean result = manageService.deleteDrugManage(dto);
            resultMap.put("result", result ? "success" : "fail");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    // ========== 감염감시 ==========

    @RequestMapping(value = "/getInfectionList.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getInfectionList(InfectionDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            List<InfectionDTO> list = manageService.getInfectionList(dto);
            resultMap.put("result", "success");
            resultMap.put("data", list);
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/saveInfection.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> saveInfection(InfectionDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            if (dto.getHospCd() == null || dto.getHospCd().isEmpty()) {
                dto.setHospCd("12345678");
            }
            boolean result;
            if ("U".equals(dto.getMode())) {
                result = manageService.updateInfection(dto);
            } else {
                result = manageService.insertInfection(dto);
            }
            resultMap.put("result", result ? "success" : "fail");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/deleteInfection.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> deleteInfection(InfectionDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            boolean result = manageService.deleteInfection(dto);
            resultMap.put("result", result ? "success" : "fail");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    // ========== 손위생 ==========

    @RequestMapping(value = "/getHandHygieneList.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getHandHygieneList(HandHygieneDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            List<HandHygieneDTO> list = manageService.getHandHygieneList(dto);
            resultMap.put("result", "success");
            resultMap.put("data", list);
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/saveHandHygiene.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> saveHandHygiene(HandHygieneDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            if (dto.getHospCd() == null || dto.getHospCd().isEmpty()) {
                dto.setHospCd("12345678");
            }
            boolean result;
            if ("U".equals(dto.getMode())) {
                result = manageService.updateHandHygiene(dto);
            } else {
                result = manageService.insertHandHygiene(dto);
            }
            resultMap.put("result", result ? "success" : "fail");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/deleteHandHygiene.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> deleteHandHygiene(HandHygieneDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            boolean result = manageService.deleteHandHygiene(dto);
            resultMap.put("result", result ? "success" : "fail");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }
}
