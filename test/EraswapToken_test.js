
const EraswapToken = artifacts.require('./EraswapToken.sol')
const { BN, constants, expectEvent, shouldFail } = require('openzeppelin-test-helpers');
var chai = require('chai')
  , chaiHttp = require('chai-http');
 
chai.use(chaiHttp);

should=chai.should();

contract('EraswapToken', function ([_, initialHolder, recipient, anotherAccount]) {
  const initialSupply = '910000000000000000000000000';
  const cap ='9100000000000000000000000000';
  //const ANRT = 0.9* initialSupply;
  const ANRT ='819000000000000000000000000';
  const MNRT = '68250000000000000000000000';
  //const MNRT = ANRT/12;

  //const initialSupply = new BN(100);


    beforeEach(async function () {
    this.token = await EraswapToken.new(initialHolder, initialSupply);
  });


  describe('name', () => {
    it('returns the name of tokens', async function () {
      (await this.token.name()).should.be.equal("Eraswap");
    });

  })


  describe('totalSupply', function () {
    it('returns the total amount of tokens', async function () {
      (await this.token.totalSupply()).should.be.bignumber.equal(initialSupply);
    });
  });

  describe('when the requested account has some tokens', function () {
    it('returns the balance of tokens', async function () {
      (await this.token.balanceOf(initialHolder)).should.be.bignumber.equal('0');
      console.log("holder",initialHolder);
    });
  });


  describe('decimals', () => {
    it('returns the decimals of tokens', async function () {
      (await this.token.decimals()).should.be.bignumber.equal('18');
    });
  })

  describe('cap', () => {
    it('returns the cap value', async function () {
      (await this.token.cap()).should.be.bignumber.equal(cap);
    });
  })


  describe('MonthCount', () => {
    it('returns the MonthCount', async function () {
      (await this.token.MonthCount()).should.be.bignumber.equal('0');
    });
  })


  describe('AnnualNRTAmount', () => {
    it('returns the AnnualNRTAmount', async function () {
      (await this.token.AnnualNRTAmount()).should.be.bignumber.equal(ANRT);
    });
  })

  describe('symbol', () => {
    it('returns the symbol of tokens', async function () {
      (await this.token.symbol()).should.be.equal('EST');
    });
  })

  describe('when the requested account has some tokens', function () {
    it('returns the total amount of tokens', async function () {
      (await this.token.balanceOf(initialHolder)).should.be.bignumber.equal('0');
      //console.log(this.token.totalsupply());
    });
  });


  describe('MonthlyNRTAmount', function()  {
    it('returns the total amount of tokens', async function () {
      console.log("mon",MNRT);
      (await this.token.MonthlyNRTAmount()).should.be.bignumber.equal(MNRT);
      //console.log(this.token.totalsupply());
    });
  });


})
