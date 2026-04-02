package egovframework.wnn_cert.manage.service;

import egovframework.wnn_cert.manage.model.*;

import java.util.List;

public interface ManageService {
    // 예방접종
    List<VaccinDTO> getVaccinList(VaccinDTO dto) throws Exception;
    boolean insertVaccin(VaccinDTO dto) throws Exception;
    boolean updateVaccin(VaccinDTO dto) throws Exception;
    boolean deleteVaccin(VaccinDTO dto) throws Exception;
    // 격리/강박
    List<RestraintDTO> getRestraintList(RestraintDTO dto) throws Exception;
    boolean insertRestraint(RestraintDTO dto) throws Exception;
    boolean updateRestraint(RestraintDTO dto) throws Exception;
    boolean deleteRestraint(RestraintDTO dto) throws Exception;
    // 소방설비
    List<FireEquipDTO> getFireEquipList(FireEquipDTO dto) throws Exception;
    boolean insertFireEquip(FireEquipDTO dto) throws Exception;
    boolean updateFireEquip(FireEquipDTO dto) throws Exception;
    boolean deleteFireEquip(FireEquipDTO dto) throws Exception;
    // 직원교육
    List<StaffEduDTO> getStaffEduList(StaffEduDTO dto) throws Exception;
    boolean insertStaffEdu(StaffEduDTO dto) throws Exception;
    boolean updateStaffEdu(StaffEduDTO dto) throws Exception;
    boolean deleteStaffEdu(StaffEduDTO dto) throws Exception;
    // 교육참석자
    List<StaffEduAttDTO> getStaffEduAttList(StaffEduAttDTO dto) throws Exception;
    boolean insertStaffEduAtt(StaffEduAttDTO dto) throws Exception;
    boolean updateStaffEduAtt(StaffEduAttDTO dto) throws Exception;
    boolean deleteStaffEduAtt(StaffEduAttDTO dto) throws Exception;
    // 건강검진
    List<HealthChkDTO> getHealthChkList(HealthChkDTO dto) throws Exception;
    boolean insertHealthChk(HealthChkDTO dto) throws Exception;
    boolean updateHealthChk(HealthChkDTO dto) throws Exception;
    boolean deleteHealthChk(HealthChkDTO dto) throws Exception;
    // 의료기기
    List<MedDeviceDTO> getMedDeviceList(MedDeviceDTO dto) throws Exception;
    boolean insertMedDevice(MedDeviceDTO dto) throws Exception;
    boolean updateMedDevice(MedDeviceDTO dto) throws Exception;
    boolean deleteMedDevice(MedDeviceDTO dto) throws Exception;
    // 당직/인력
    List<StaffDutyDTO> getStaffDutyList(StaffDutyDTO dto) throws Exception;
    boolean insertStaffDuty(StaffDutyDTO dto) throws Exception;
    boolean updateStaffDuty(StaffDutyDTO dto) throws Exception;
    boolean deleteStaffDuty(StaffDutyDTO dto) throws Exception;
    // 배식라운딩
    List<MealRoundDTO> getMealRoundList(MealRoundDTO dto) throws Exception;
    boolean insertMealRound(MealRoundDTO dto) throws Exception;
    boolean updateMealRound(MealRoundDTO dto) throws Exception;
    boolean deleteMealRound(MealRoundDTO dto) throws Exception;
    // 약품관리
    List<DrugManageDTO> getDrugManageList(DrugManageDTO dto) throws Exception;
    boolean insertDrugManage(DrugManageDTO dto) throws Exception;
    boolean updateDrugManage(DrugManageDTO dto) throws Exception;
    boolean deleteDrugManage(DrugManageDTO dto) throws Exception;
    // 감염감시
    List<InfectionDTO> getInfectionList(InfectionDTO dto) throws Exception;
    boolean insertInfection(InfectionDTO dto) throws Exception;
    boolean updateInfection(InfectionDTO dto) throws Exception;
    boolean deleteInfection(InfectionDTO dto) throws Exception;
    // 손위생
    List<HandHygieneDTO> getHandHygieneList(HandHygieneDTO dto) throws Exception;
    boolean insertHandHygiene(HandHygieneDTO dto) throws Exception;
    boolean updateHandHygiene(HandHygieneDTO dto) throws Exception;
    boolean deleteHandHygiene(HandHygieneDTO dto) throws Exception;
}
