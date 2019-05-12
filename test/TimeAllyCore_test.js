
/**
 * This file was created by truffle-test-generator.
 * For every test, a new contract will be created in the
 * top beforeEach block. This line uses the arguments for
 * your contract's constructor with the same variable names.
 * Each public, non-constant (view) method has a describe
 * block generated for it.
 */
const TimeAllyCore = artifacts.require('TimeAllyCore')

contract('TimeAllyCore', (accounts) => {
  const maintainer = accounts[0]
  const user1 = accounts[1]
  const user2 = accounts[2]
  const stranger = accounts[3]

  let timeallycore

  beforeEach(async () => {
    timeallycore = await TimeAllyCore.new({from: maintainer})
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

  describe('EraswapTokenAddress', () => {

  })

  describe('PlanID', () => {

  })

  describe('LoanandRefundAddress', () => {

  })

  describe('LastMonthlyHandler', () => {

  })

  describe('Setaddress', () => {

  })

  describe('MonthlyMasterHandler', () => {

  })

  describe('MonthlyPlansHandler', () => {

  })

  describe('MonthlyPaymentHandler', () => {

  })
})
