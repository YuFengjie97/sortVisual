<script lang="jsx">
import { ref, watch, watchEffect } from "vue"
import { height } from "tailwindcss/defaultTheme"
export default {
  props: {
    arr: {
      type: Array,
      default: () => [],
    },
  },
  setup(props) {
    console.log("grid props", props)
    let max
    let barWidth = 30
    let gap = 10

    function getHeight(val) {
      const minH = 30
      const maxH = 400
      const valH = (maxH / max) * val
      return valH < minH ? minH : valH
    }

    return () => {
      max = Math.max(...props.arr)
      console.log({ max, arr: props.arr })

      return (
        <div class="gridCon">
          {props.arr.map((item, i) => {
            const height = parseInt(getHeight(item))
            const styleObj = {
              width: `${barWidth}px`,
              height: `${height}px`,
              left: `${(barWidth + gap) * i}px`,
            }
            return (
              <div style={styleObj} class="item">
                {item}
              </div>
            )
          })}
        </div>
      )
    }
  },
}
</script>

<style lang="less" scoped>
.gridCon {
  border: 1px solid #000;
  position: relative;
  height: 400px;
  .item {
    position: absolute;
    bottom: 0;
    background: #0984e3;
    color: #fff;
    text-align: center;
  }
}
</style>
