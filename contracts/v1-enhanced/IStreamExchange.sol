// SPDX-License-Identifier: AGPLv3
pragma solidity ^0.8.0;

// import { ISuperAgreement } from "ricochet-exchange-sfcontracts-used/ethereum-contracts/contracts/interfaces/superfluid/ISuperAgreement.sol";
import "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperToken.sol";

/**
 * @title Stream Exchange interface.
 *
 * @author Ricochet
 */
interface IStreamExchange {
    // function initVars() private; // No because it's internal

    /**************************************************************************
     * Stream Exchange Logic
     *************************************************************************/
    function distribute() external;

    /// @dev Close stream from `streamer` address if balance is less than 8 hours of streaming
    // function closeStream(address streamer) public;
    function closeStream(address streamer) external;

    /// @dev Allows anyone to close any stream if the app is jailed.
    /// @param streamer is stream source (streamer) address
    function emergencyCloseStream(address streamer) external;

    /// @dev Drain contract's input and output tokens balance to owner if SuperApp dont have any input streams.
    function emergencyDrain() external;

    /// @dev Set subsidy rate
    /// @param subsidyRate is new rate
    function setSubsidyRate(uint128 subsidyRate) external; // onlyOwner;

    /// @dev Set fee rate
    /// @param feeRate is new fee rate
    function setFeeRate(uint128 feeRate) external;

    /// @dev Set rate tolerance
    /// @param rateTolerance is new rate tolerance
    function setRateTolerance(uint128 rateTolerance) external;

    function setOracle(address oracle) external;

    function setRequestId(uint256 requestId) external;

    function isAppJailed() external view returns (bool);

    /// @dev Get `streamer` IDA subscription info for token with index `index`
    /// @param index is token index in IDA
    /// @param streamer is streamer address
    /// @return exist Does the subscription exist?
    /// @return approved Is the subscription approved?
    /// @return units Units of the suscription.
    /// @return pendingDistribution Pending amount of tokens to be distributed for unapproved subscription.
    function getIDAShares(uint32 index, address streamer) external view;

    // returns (
    //     bool exist,
    //     bool approved,
    //     uint128 units,
    //     uint256 pendingDistribution
    // );

    function getInputToken() external view returns (ISuperToken);

    function getOuputToken() external view returns (ISuperToken);

    function getOuputIndexId() external view returns (uint32);

    function getSubsidyToken() external view returns (ISuperToken);

    function getSubsidyIndexId() external view returns (uint32);

    function getSubsidyRate() external view returns (uint256);

    function getTotalInflow() external view returns (int96);

    function getLastDistributionAt() external view returns (uint256);

    function getSushiRouter() external view returns (address);

    function getTellorOracle() external view returns (address);

    function getRequestId() external view returns (uint256);

    function getOwner() external view returns (address);

    function getFeeRate() external view returns (uint128);

    function getRateTolerance() external view returns (uint256);

    function getStreamRate(address streamer)
        external
        view
        returns (int96 requesterFlowRate);

    // function transferOwnership(address newOwner)
    //     public
    //     virtual
    //     override

    /**************************************************************************
     * SuperApp callbacks
     *************************************************************************/

    /// @dev SuperFluid protocol callback
    /// @dev Callback after a new agreement is created.
    /// @dev Can be called only by SuperFluid protocol host.
    /// @param _superToken The super token used for the agreement.
    /// @param _agreementClass The agreement class address.
    /// @param _agreementData The agreement data (non-compressed)
    /// @param _ctx The context data.
    /// @return newCtx The current context of the transaction.
    function afterAgreementCreated(
        ISuperToken _superToken,
        address _agreementClass,
        bytes32, // _agreementId,
        bytes calldata _agreementData,
        bytes calldata, // _cbdata,
        bytes calldata _ctx
    ) external returns (bytes memory newCtx);

    /// @dev SuperFluid protocol callback
    /// @dev Callback after a new agreement is updated.
    /// @dev Can be called only by SuperFluid protocol host.
    /// @param _superToken The super token used for the agreement.
    /// @param _agreementClass The agreement class address.
    /// @param _agreementData The agreement data (non-compressed)
    /// @param _ctx The context data.
    /// @return newCtx The current context of the transaction.
    function afterAgreementUpdated(
        ISuperToken _superToken,
        address _agreementClass,
        bytes32, //_agreementId,
        bytes calldata _agreementData,
        bytes calldata, //_cbdata,
        bytes calldata _ctx
    )
        external
        returns (
            // override
            // onlyExpected(_superToken, _agreementClass)
            // onlyHost
            bytes memory newCtx
        );

    /// @dev SuperFluid protocol callback
    /// @dev Callback after a new agreement is terminated.
    /// @dev Can be called only by SuperFluid protocol host.
    /// @param _superToken The super token used for the agreement.
    /// @param _agreementClass The agreement class address.
    /// @param _agreementData The agreement data (non-compressed)
    /// @param _ctx The context data.
    /// @return newCtx The current context of the transaction.
    function afterAgreementTerminated(
        ISuperToken _superToken,
        address _agreementClass,
        bytes32, //_agreementId,
        bytes calldata _agreementData,
        bytes calldata, //_cbdata,
        bytes calldata _ctx
    ) external returns (bytes memory newCtx);

    // /// @dev Restricts calls to only from SuperFluid host
    // modifier onlyHost() {
    //     require(msg.sender == address(_exchange.host), "one host");
    //     _;
    // }

    /// @dev Accept only input token for CFA, output and subsidy tokens for IDA
    // modifier onlyExpected(ISuperToken superToken, address agreementClass) {
    //     if (_exchange._isCFAv1(agreementClass)) {
    //         require(_exchange._isInputToken(superToken), "!inputAccepted");
    //     } else if (_exchange._isIDAv1(agreementClass)) {
    //         require(
    //             _exchange._isOutputToken(superToken) ||
    //                 _exchange._isSubsidyToken(superToken),
    //             "!outputAccepted"
    //         );
    //     }
    //     _;
    // }
}
