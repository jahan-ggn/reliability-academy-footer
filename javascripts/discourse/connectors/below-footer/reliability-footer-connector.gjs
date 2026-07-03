import ReliabilityFooter from "../../components/reliability-footer";

const ReliabilityFooterConnector = <template>
  <div class="below-footer-outlet">
    <ReliabilityFooter @showFooter={{@outletArgs.showFooter}} />
  </div>
</template>;

export default ReliabilityFooterConnector;
