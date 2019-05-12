
/**
 * This file was created by truffle-test-generator.
 * For every test, a new contract will be created in the
 * top beforeEach block. This line uses the arguments for
 * your contract's constructor with the same variable names.
 * Each public, non-constant (view) method has a describe
 * block generated for it.
 */
const TimeAlly = artifacts.require('TimeAlly')

contract('TimeAlly', (accounts) => {
  const maintainer = accounts[0]
  const user1 = accounts[1]
  const user2 = accounts[2]
  const stranger = accounts[3]

  let timeally

  // Be sure to update these constructor values
  let eraswapTokenAddress = 0

  beforeEach(async () => {
    timeally = await TimeAlly.new(eraswapTokenAddress, {from: maintainer})
  })

  describe('PlanHandlerCount', () => {

  })

  describe('Plans', () => {

  })

  describe('TokenTransferList', () => {

  })

  describe('ContractID', () => {

  })

  describe('LoanRepaymentAmount', () => {

  })

  describe('MonthlyHandlerCount', () => {

  })

  describe('Contracts', () => {

  })

  describe('StakingAddress', () => {

  })

  describe('MonthlyPaymentHandler', () => {

  })

  describe('EraswapTokenAddress', () => {

  })

  describe('PlanID', () => {

  })

  describe('MonthlyMasterHandler', () => {

  })

  describe('MonthlyPlansHandler', () => {

  })

  describe('Setaddress', () => {

  })

  describe('LoanandRefundAddress', () => {

  })

  describe('LastMonthlyHandler', () => {

  })

  describe('ViewContract', () => {

  })

  describe('ViewUserStakes', () => {

  })

  describe('ViewUserLoan', () => {

  })

  describe('ViewUserRefund', () => {

  })

  describe('AllContracts', () => {

  })

  describe('PlanDetails', () => {

  })

  describe('CreateContract', () => {

  })

  describe('CreateContractsByBatch', () => {

  })

  describe('CreatePlan', () => {

  })

  describe('windUpContract', () => {

  })

  describe('takeLoan', () => {

  })

  describe('rePayLoan', () => {

  })

  describe('transferOwnership', () => {

  })
})
