package egovframework.wnn_cert.manage.service.impl;

import egovframework.wnn_cert.manage.mapper.ManageMapper;
import egovframework.wnn_cert.manage.model.*;
import egovframework.wnn_cert.manage.service.ManageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("ManageService")
public class ManageServiceImpl implements ManageService {

    @Autowired
    private ManageMapper manageMapper;

    // 예방접종
    @Override
    public List<VaccinDTO> getVaccinList(VaccinDTO dto) throws Exception {
        return manageMapper.getVaccinList(dto);
    }

    @Override
    public boolean insertVaccin(VaccinDTO dto) throws Exception {
        return manageMapper.insertVaccin(dto);
    }

    @Override
    public boolean updateVaccin(VaccinDTO dto) throws Exception {
        return manageMapper.updateVaccin(dto);
    }

    @Override
    public boolean deleteVaccin(VaccinDTO dto) throws Exception {
        return manageMapper.deleteVaccin(dto);
    }

    // 격리/강박
    @Override
    public List<RestraintDTO> getRestraintList(RestraintDTO dto) throws Exception {
        return manageMapper.getRestraintList(dto);
    }

    @Override
    public boolean insertRestraint(RestraintDTO dto) throws Exception {
        return manageMapper.insertRestraint(dto);
    }

    @Override
    public boolean updateRestraint(RestraintDTO dto) throws Exception {
        return manageMapper.updateRestraint(dto);
    }

    @Override
    public boolean deleteRestraint(RestraintDTO dto) throws Exception {
        return manageMapper.deleteRestraint(dto);
    }

    // 소방설비
    @Override
    public List<FireEquipDTO> getFireEquipList(FireEquipDTO dto) throws Exception {
        return manageMapper.getFireEquipList(dto);
    }

    @Override
    public boolean insertFireEquip(FireEquipDTO dto) throws Exception {
        return manageMapper.insertFireEquip(dto);
    }

    @Override
    public boolean updateFireEquip(FireEquipDTO dto) throws Exception {
        return manageMapper.updateFireEquip(dto);
    }

    @Override
    public boolean deleteFireEquip(FireEquipDTO dto) throws Exception {
        return manageMapper.deleteFireEquip(dto);
    }

    // 직원교육
    @Override
    public List<StaffEduDTO> getStaffEduList(StaffEduDTO dto) throws Exception {
        return manageMapper.getStaffEduList(dto);
    }

    @Override
    public boolean insertStaffEdu(StaffEduDTO dto) throws Exception {
        return manageMapper.insertStaffEdu(dto);
    }

    @Override
    public boolean updateStaffEdu(StaffEduDTO dto) throws Exception {
        return manageMapper.updateStaffEdu(dto);
    }

    @Override
    public boolean deleteStaffEdu(StaffEduDTO dto) throws Exception {
        return manageMapper.deleteStaffEdu(dto);
    }

    // 교육참석자
    @Override
    public List<StaffEduAttDTO> getStaffEduAttList(StaffEduAttDTO dto) throws Exception {
        return manageMapper.getStaffEduAttList(dto);
    }

    @Override
    public boolean insertStaffEduAtt(StaffEduAttDTO dto) throws Exception {
        return manageMapper.insertStaffEduAtt(dto);
    }

    @Override
    public boolean updateStaffEduAtt(StaffEduAttDTO dto) throws Exception {
        return manageMapper.updateStaffEduAtt(dto);
    }

    @Override
    public boolean deleteStaffEduAtt(StaffEduAttDTO dto) throws Exception {
        return manageMapper.deleteStaffEduAtt(dto);
    }

    // 건강검진
    @Override
    public List<HealthChkDTO> getHealthChkList(HealthChkDTO dto) throws Exception {
        return manageMapper.getHealthChkList(dto);
    }

    @Override
    public boolean insertHealthChk(HealthChkDTO dto) throws Exception {
        return manageMapper.insertHealthChk(dto);
    }

    @Override
    public boolean updateHealthChk(HealthChkDTO dto) throws Exception {
        return manageMapper.updateHealthChk(dto);
    }

    @Override
    public boolean deleteHealthChk(HealthChkDTO dto) throws Exception {
        return manageMapper.deleteHealthChk(dto);
    }

    // 의료기기
    @Override
    public List<MedDeviceDTO> getMedDeviceList(MedDeviceDTO dto) throws Exception {
        return manageMapper.getMedDeviceList(dto);
    }

    @Override
    public boolean insertMedDevice(MedDeviceDTO dto) throws Exception {
        return manageMapper.insertMedDevice(dto);
    }

    @Override
    public boolean updateMedDevice(MedDeviceDTO dto) throws Exception {
        return manageMapper.updateMedDevice(dto);
    }

    @Override
    public boolean deleteMedDevice(MedDeviceDTO dto) throws Exception {
        return manageMapper.deleteMedDevice(dto);
    }

    // 당직/인력
    @Override
    public List<StaffDutyDTO> getStaffDutyList(StaffDutyDTO dto) throws Exception {
        return manageMapper.getStaffDutyList(dto);
    }

    @Override
    public boolean insertStaffDuty(StaffDutyDTO dto) throws Exception {
        return manageMapper.insertStaffDuty(dto);
    }

    @Override
    public boolean updateStaffDuty(StaffDutyDTO dto) throws Exception {
        return manageMapper.updateStaffDuty(dto);
    }

    @Override
    public boolean deleteStaffDuty(StaffDutyDTO dto) throws Exception {
        return manageMapper.deleteStaffDuty(dto);
    }

    // 배식라운딩
    @Override
    public List<MealRoundDTO> getMealRoundList(MealRoundDTO dto) throws Exception {
        return manageMapper.getMealRoundList(dto);
    }

    @Override
    public boolean insertMealRound(MealRoundDTO dto) throws Exception {
        return manageMapper.insertMealRound(dto);
    }

    @Override
    public boolean updateMealRound(MealRoundDTO dto) throws Exception {
        return manageMapper.updateMealRound(dto);
    }

    @Override
    public boolean deleteMealRound(MealRoundDTO dto) throws Exception {
        return manageMapper.deleteMealRound(dto);
    }

    // 약품관리
    @Override
    public List<DrugManageDTO> getDrugManageList(DrugManageDTO dto) throws Exception {
        return manageMapper.getDrugManageList(dto);
    }

    @Override
    public boolean insertDrugManage(DrugManageDTO dto) throws Exception {
        return manageMapper.insertDrugManage(dto);
    }

    @Override
    public boolean updateDrugManage(DrugManageDTO dto) throws Exception {
        return manageMapper.updateDrugManage(dto);
    }

    @Override
    public boolean deleteDrugManage(DrugManageDTO dto) throws Exception {
        return manageMapper.deleteDrugManage(dto);
    }

    // 감염감시
    @Override
    public List<InfectionDTO> getInfectionList(InfectionDTO dto) throws Exception {
        return manageMapper.getInfectionList(dto);
    }

    @Override
    public boolean insertInfection(InfectionDTO dto) throws Exception {
        return manageMapper.insertInfection(dto);
    }

    @Override
    public boolean updateInfection(InfectionDTO dto) throws Exception {
        return manageMapper.updateInfection(dto);
    }

    @Override
    public boolean deleteInfection(InfectionDTO dto) throws Exception {
        return manageMapper.deleteInfection(dto);
    }

    // 손위생
    @Override
    public List<HandHygieneDTO> getHandHygieneList(HandHygieneDTO dto) throws Exception {
        return manageMapper.getHandHygieneList(dto);
    }

    @Override
    public boolean insertHandHygiene(HandHygieneDTO dto) throws Exception {
        return manageMapper.insertHandHygiene(dto);
    }

    @Override
    public boolean updateHandHygiene(HandHygieneDTO dto) throws Exception {
        return manageMapper.updateHandHygiene(dto);
    }

    @Override
    public boolean deleteHandHygiene(HandHygieneDTO dto) throws Exception {
        return manageMapper.deleteHandHygiene(dto);
    }
}
