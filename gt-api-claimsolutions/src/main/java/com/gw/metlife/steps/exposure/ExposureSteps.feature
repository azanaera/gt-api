Feature: Exposure
  Step scenarios that operate on Claim Exposures

  Background:
    * def username = claimsDataContainer.getClaimsUser(__arg.cucumberDataCache.currentUserRole).getName()

  @id=CreateExposureForVehicle
  Scenario: I create an exposure for the vehicle
    * def unrestrictedUsername = claimUtils.getUnrestrictedUser()
    When step('ExposureActions.CreateVehicleIncidentExposure', {'scenarioArgs': {'username': unrestrictedUsername, 'claimId': __arg.cucumberDataCache.claimId, 'vehicleIncidentType': __arg.cucumberDataCache.vehicleIncidentType}, 'templateArgs': {'claimantId': __arg.cucumberDataCache.insuredId, 'incidentId': __arg.cucumberDataCache.incidentId}})
    * __arg.cucumberDataCache.exposureId = getStepVariable('ExposureActions.CreateVehicleIncidentExposure', 'exposureId')

  @id=CreateAnExposure
  Scenario: with an {string} exposure; with an {string} first exposure; an {string} second exposure
    * def parameters = ['exposureSegment']
    * def vehicleIncidentType = 'withAttributes'
    * def setIncidentAttributes =
    """
    function(exposureSegment) {
      if (exposureSegment == "Auto - low complexity") {
        driverId = __arg.cucumberDataCache.insuredId
        lossParty = "insured"
        severity = "minor"
        totalLoss = false
      }
      else if (exposureSegment == "Auto - mid complexity") {
        step('ContactActions.CreateThirdPartyContact', {'scenarioArgs': {'username': username, 'claimId': __arg.cucumberDataCache.claimId}})
        driverId = getStepVariable('ContactActions.CreateThirdPartyContact', 'thirdPartyContactId')
        lossParty = "third_party"
        severity = "major-auto"
        totalLoss = true
      }
      else if (exposureSegment == "Auto - high complexity") {
        driverId = __arg.cucumberDataCache.insuredId
        lossParty = "insured"
        severity = "major-auto"
        totalLoss = true
      }
    }
    """
    * def setExposureAttributes =
    """
    function(exposureSegment) {
      claimantId = driverId
      if (exposureSegment == "Auto - low complexity" || exposureSegment == "Auto - high complexity") {
        claimantType = "insured"
        coverageSubtype = "PACollisionCov"
        lossParty = "insured"
        primaryCoverage = "PACollisionCov"
      }
      else if (exposureSegment == "Auto - mid complexity") {
        claimantType = "veh_other_driver"
        coverageSubtype = "PALiabilityCov_vd"
        lossParty = "third_party"
        primaryCoverage = "PALiabilityCov"
      }
    }
    """
    * call setIncidentAttributes(__arg.parameters.exposureSegment)
    Given step('IncidentActions.CreateVehicleIncident', {'scenarioArgs':{'username': username, 'claimId': __arg.cucumberDataCache.claimId, 'vehicleIncidentType': vehicleIncidentType}, 'templateArgs': {'driverId': driverId, 'lossParty': lossParty, 'severity': severity, 'totalLoss': totalLoss}})
    * def vehicleIncidentId = getStepVariable('IncidentActions.CreateVehicleIncident', 'vehicleIncidentId')
    * call setExposureAttributes(__arg.parameters.exposureSegment)
    When step('ExposureActions.CreateVehicleIncidentExposure', {'scenarioArgs': {'username': username, 'claimId': __arg.cucumberDataCache.claimId, 'vehicleIncidentType': vehicleIncidentType}, 'templateArgs': {'claimantId': claimantId, 'claimantType': claimantType, 'coverageSubtype': coverageSubtype, 'lossParty': lossParty, 'primaryCoverage': primaryCoverage, 'incidentId': vehicleIncidentId}})
    * __arg.cucumberDataCache.exposureId = getStepVariable('ExposureActions.CreateVehicleIncidentExposure', 'exposureId')

  @id=CreateExposureWithMinorInjuredDriver
  Scenario: with the insured vehicle with a minor injured driver
    * def vehicleIncidentType = 'insured'
    * def injuryIncidentType = 'minor'
    Given step('IncidentActions.CreateVehicleIncident', {'scenarioArgs': {'username': username, 'claimId': __arg.cucumberDataCache.claimId, 'vehicleIncidentType': vehicleIncidentType}, 'templateArgs': {'driverId': __arg.cucumberDataCache.insuredId, 'policyVehicleId': __arg.cucumberDataCache.policyVehicleId}})
    * def vehicleIncidentId = getStepVariable('IncidentActions.CreateVehicleIncident', 'vehicleIncidentId')
    And step('IncidentActions.CreateInjuryIncident', {'scenarioArgs': {'username': username, 'claimId': __arg.cucumberDataCache.claimId, 'injuryIncidentType': injuryIncidentType}, 'templateArgs': {'injuredPersonId': __arg.cucumberDataCache.insuredId}})
    * def injuryIncidentId = getStepVariable('IncidentActions.CreateInjuryIncident', 'injuryIncidentId')
    When step('ExposureActions.CreateVehicleIncidentExposure', {'scenarioArgs': {'username': username, 'claimId': __arg.cucumberDataCache.claimId, 'vehicleIncidentType': vehicleIncidentType}, 'templateArgs': {'claimantId': __arg.cucumberDataCache.insuredId, 'incidentId': vehicleIncidentId}})
    And step('ExposureActions.CreateInjuryIncidentExposure', {'scenarioArgs': {'username': username, 'claimId': __arg.cucumberDataCache.claimId}, 'templateArgs': {'claimantId': __arg.cucumberDataCache.insuredId, 'incidentId': injuryIncidentId}})
    * __arg.cucumberDataCache.exposureId = getStepVariable('ExposureActions.CreateInjuryIncidentExposure', 'exposureId')

  @id=CreateExposureWithThirdPartyVehicle
  Scenario: with a third party vehicle
    * def vehicleIncidentType = 'third-party'
    Given step('ContactActions.CreateThirdPartyContact', {'scenarioArgs': {'username': username, 'claimId': __arg.cucumberDataCache.claimId}})
    * def thirdPartyContactId = getStepVariable('ContactActions.CreateThirdPartyContact', 'thirdPartyContactId')
    And step('IncidentActions.CreateVehicleIncident', {'scenarioArgs': {'username': username, 'claimId': __arg.cucumberDataCache.claimId, 'vehicleIncidentType': vehicleIncidentType}, 'templateArgs': {'driverId': thirdPartyContactId}})
    * def vehicleIncidentId = getStepVariable('IncidentActions.CreateVehicleIncident', 'vehicleIncidentId')
    When step('ExposureActions.CreateVehicleIncidentExposure', {'scenarioArgs': {'username': username, 'claimId': __arg.cucumberDataCache.claimId, 'vehicleIncidentType': vehicleIncidentType}, 'templateArgs': {'claimantId': thirdPartyContactId, 'incidentId': vehicleIncidentId}})
    * __arg.cucumberDataCache.exposureId = getStepVariable('ExposureActions.CreateVehicleIncidentExposure', 'exposureId')

  @id=CreateExposureWithFatallyInjuredDriver
  Scenario: with the insured vehicle with a fatally injured driver
    * def vehicleIncidentType = 'insured'
    * def injuryIncidentType = 'fatal'
    Given step('IncidentActions.CreateVehicleIncident', {'scenarioArgs': {'username': username, 'claimId': __arg.cucumberDataCache.claimId, 'vehicleIncidentType': vehicleIncidentType}, 'templateArgs': {'driverId': __arg.cucumberDataCache.insuredId, 'policyVehicleId': __arg.cucumberDataCache.policyVehicleId}})
    * def vehicleIncidentId = getStepVariable('IncidentActions.CreateVehicleIncident', 'vehicleIncidentId')
    And step('IncidentActions.CreateInjuryIncident', {'scenarioArgs': {'username': username, 'claimId': __arg.cucumberDataCache.claimId, 'injuryIncidentType': injuryIncidentType}, 'templateArgs': {'injuredPersonId': __arg.cucumberDataCache.insuredId}})
    * def injuryIncidentId = getStepVariable('IncidentActions.CreateInjuryIncident', 'injuryIncidentId')
    When step('ExposureActions.CreateVehicleIncidentExposure', {'scenarioArgs': {'username': username, 'claimId': __arg.cucumberDataCache.claimId, 'vehicleIncidentType': vehicleIncidentType}, 'templateArgs': {'claimantId': __arg.cucumberDataCache.insuredId, 'incidentId': vehicleIncidentId}})
    And step('ExposureActions.CreateInjuryIncidentExposure', {'scenarioArgs': {'username': username, 'claimId': __arg.cucumberDataCache.claimId}, 'templateArgs': {'claimantId': __arg.cucumberDataCache.insuredId, 'incidentId': injuryIncidentId}})
    * __arg.cucumberDataCache.exposureId = getStepVariable('ExposureActions.CreateInjuryIncidentExposure', 'exposureId')

  @id=CreateExposureWithTotalLossVehicle
  Scenario: with the insured vehicle being a total loss
    * def vehicleIncidentType = 'totalLossInsured'
    Given step('IncidentActions.CreateVehicleIncident', {'scenarioArgs':{'username': username, 'claimId': __arg.cucumberDataCache.claimId, 'vehicleIncidentType': vehicleIncidentType}, 'templateArgs': {'driverId': __arg.cucumberDataCache.insuredId, 'policyVehicleId': __arg.cucumberDataCache.policyVehicleId}})
    * def vehicleIncidentId = getStepVariable('IncidentActions.CreateVehicleIncident', 'vehicleIncidentId')
    When step('ExposureActions.CreateVehicleIncidentExposure', {'scenarioArgs': {'username': username, 'claimId': __arg.cucumberDataCache.claimId, 'vehicleIncidentType': vehicleIncidentType}, 'templateArgs': {'claimantId': __arg.cucumberDataCache.insuredId, 'incidentId': vehicleIncidentId}})
    * __arg.cucumberDataCache.exposureId = getStepVariable('ExposureActions.CreateVehicleIncidentExposure', 'exposureId')

  @id=CovSubtypeExposureExists
  Scenario: a {string} exposure exists
    * def parameters = ['coverageSubtype']
    * def unrestrictedUsername = claimUtils.getUnrestrictedUser()
    When step('ExposureActions.GetExposureByCovSubtype', {'scenarioArgs': {'username': unrestrictedUsername, 'claimId': __arg.cucumberDataCache.claimId, 'coverageSubtype': __arg.parameters.coverageSubtype}})

  @id=ExposureAssignedClaimOwner
  Scenario: the exposure is assigned to the claim owner
    * def unrestrictedUsername = claimUtils.getUnrestrictedUser()
    When step('ExposureActions.GetExposure', {'scenarioArgs': {'username': unrestrictedUsername, 'claimId': __arg.cucumberDataCache.claimId, 'exposureId': __arg.cucumberDataCache.exposureId}})
    * def exposureOwnerId = getStepVariable('ExposureActions.GetExposure', 'exposureOwnerId')
    When step('ExposureActions.MatchExposureOwnerWithClaimOwner', {'scenarioArgs': {'exposureOwnerId': exposureOwnerId, 'claimOwnerId': __arg.cucumberDataCache.claimOwnerId}})

  @id=GetExposureSegment
  Scenario: the exposure is segmented as {string}
    * def parameters = ['exposureSegment']
    * def unrestrictedUsername = claimUtils.getUnrestrictedUser()
    Given step('ExposureActions.GetExposureSegment', {'scenarioArgs': {'username': unrestrictedUsername, 'claimId': __arg.cucumberDataCache.claimId, 'exposureId': __arg.cucumberDataCache.exposureId, 'exposureSegment': __arg.parameters.exposureSegment}})