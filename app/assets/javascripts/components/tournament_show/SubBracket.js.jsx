class SubBracket extends React.Component {
  constructor(props) {
    super(props);
    console.log("SubBracket Props Object: ", this.props)
  }
  
  render() {
    
    return(
      <section className="sub_bracket">
        <div>SubBracket Component Render Method</div>
        <br />
      </section>
    );
  }
}